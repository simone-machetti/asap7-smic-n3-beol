# -----------------------------------------------------------------------------
# Author: Simone Machetti
# SPDX-License-Identifier: Apache-2.0
# -----------------------------------------------------------------------------
#
# Routing tracks of the smic-n3 stack. M1 and M2 are ASAP7's, unchanged: M2 keeps
# its seven staggered lines at the 270 nm cell-row pitch, which line its tracks
# up with the pin rows of the standard cells. From M3 up the pitch of the
# preferred direction is the pitch of the technology LEF and the offset is half
# the wire width, so the first wire sits with its edge on the die boundary; the
# other direction takes the pitch of the layer below, as in ASAP7. Pad is
# ASAP7's.
# -----------------------------------------------------------------------------

make_tracks Pad -x_offset 0.116 -x_pitch 0.080 -y_offset 0.116 -y_pitch 0.080
make_tracks M11 -x_offset 0.037 -x_pitch 0.148 -y_offset 0.032 -y_pitch 0.128
make_tracks M10 -x_offset 0.032 -x_pitch 0.128 -y_offset 0.032 -y_pitch 0.128
make_tracks M9 -x_offset 0.032 -x_pitch 0.128 -y_offset 0.032 -y_pitch 0.128
make_tracks M8 -x_offset 0.032 -x_pitch 0.128 -y_offset 0.032 -y_pitch 0.128
make_tracks M7 -x_offset 0.032 -x_pitch 0.128 -y_offset 0.020 -y_pitch 0.080
make_tracks M6 -x_offset 0.020 -x_pitch 0.080 -y_offset 0.020 -y_pitch 0.080
make_tracks M5 -x_offset 0.020 -x_pitch 0.080 -y_offset 0.020 -y_pitch 0.080
make_tracks M4 -x_offset 0.011 -x_pitch 0.044 -y_offset 0.020 -y_pitch 0.080
make_tracks M3 -x_offset 0.011 -x_pitch 0.044 -y_offset 0.009 -y_pitch 0.036

make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.045 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.081 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.117 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.153 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.189 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.225 -y_pitch 0.270
make_tracks M2 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.270 -y_pitch 0.270

make_tracks M1 -x_offset 0.009 -x_pitch 0.036 -y_offset 0.009 -y_pitch 0.036
