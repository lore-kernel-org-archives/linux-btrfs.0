Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from uabexch3.ad.uab.edu ([138.26.5.132]:27397 "EHLO
	uabexch3.ad.uab.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaAUNkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 08:40:36 -0500
Message-ID: <52DE7797.30400@uab.edu>
Date: Tue, 21 Jan 2014 07:35:19 -0600
From: Kyle Bentley <kwbent@uab.edu>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Btrfs shows incorrect disk size after running a replace command
Content-Type: multipart/mixed;
	boundary="------------090304010102010701010904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------090304010102010701010904
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have just recently replaced two 750 GB disks with two 1 TB disks.  I
used the replace command to do so, aka "btrfs replace start /dev/sdX
/dev/sdY /mountpoint".  Each replacement went smoothly, with no errors
reporting.  I'm positive that the source and destination drives were
identified correctly.  However, when I run "btrfs filesystem show", the
output is

Label: none  uuid: b2dbc0e4-94fc-4089-9221-d79d7919f8cb
    Total devices 2 FS bytes used 494.23GB
    devid    2 size 698.64GB used 495.03GB path /dev/sda
    devid    1 size 698.64GB used 495.03GB path /dev/sdb

Btrfs v0.20-rc1

The disks show up as the 750 GB, when they are in fact 1 TB.  smartctl
for each drive shows

root@Lore:/home/kyle# smartctl -i /dev/sda |grep "User Capacity"
User Capacity:    1,000,204,886,016 bytes [1.00 TB]

root@Lore:/home/kyle# smartctl -i /dev/sdb |grep "User Capacity"
User Capacity:    1,000,204,886,016 bytes [1.00 TB]

Is there any harm in this?  If it is simply a superficial bug I will not
worry.  Would running a balance help?  As for the specifics, I'm using

Debian testing x64
Vanilla kernel 3.13.0
AMD hardware

Thanks,

Kyle Bentley

- ---------------------------------------
kwbent@uab.edu
UAB Dept of Physics
1300 University Blvd
CH 310
Birmingham, AL
- ---------------------------------------



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJS3neNAAoJEKZ75usGhR84secH/iIbH/FcU3pTsg7+V9vwqMgB
VuQeZpU13RH/2fwupuFJtu4wK021xWLrSuN7nUGG0WzrWSmt8nHvQqIV1TBY+2PO
QqttgbBK5yDEIY6QB3lUn2fQDWohlrbG4/3CTjILoTdHWsihTBzXIug6D6aEpM1o
1b3smiBPM6mg6sy3d+JSr47TGi8Wko1QnOh2ory5FlkJMTZLDNWBqG2ja00B7W9H
UKnwgaU3KZr9UcbiVlvM1BLgDBxRZlhsjWMMo+diX92PHgaBovhEOzCrHI/nyXv7
vY3YKcwU1zH3f0olHXfp9lFjo06C/4/+EggCrQ3BEe0hxm5r3bHc44zrTCnH/Wg=
=a/VY
-----END PGP SIGNATURE-----


--------------090304010102010701010904
Content-Type: application/pgp-keys; name="0x06851F38.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0x06851F38.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBFBIw1kBCACvhqdxbWfrnEL9X+RQnMfcCGsOx4i1nIoqrxvvQwrF15EG3EC2
UucqAmADDgjUO0f6FdkYqzyNd4sHhQkCWKAV80X6IPkq1+6VsT45uwgvB1a+wJfL
HlhkqXsBXd4PmeUevT+ZHRA2IAylYTY1D7ZgKUvcVPI5Xz6/YU1sFpsyskp2mwAc
0KyXhVxNzo15QNwFcT8I71hLojcbI4/BgyUmVZJF5hMVTvBUvcZiHDRmNQhFXnCX
5Rv/0A8fvP0gSccTrO6Qah4jpcKj+hYlFrD7rHJRilKUB9AljhbF8mpnZIM3WmSQ
vjwtdqWy7UqN/gLqV/f6bZVIbWfaeNtV15uhABEBAAG0HUt5bGUgQmVudGxleSA8
a3diZW50QHVhYi5lZHU+iQE+BBMBAgAoBQJQSMNZAhsjBQkJZgGABgsJCAcDAgYV
CAIJCgsEFgIDAQIeAQIXgAAKCRCme+brBoUfOHMOB/9U+4FUfNzSbdtkogOYQjj5
FCP/zUwnxIw1XkwMju22Bu8FcnDFn10TdkBINP6/plXVB4KUGki7izxtZW8VTBF7
uBzz//neL5ecAAGAuK+IxEPvoW6DjXApSJFx2xEvZvsM74qfszzTo6FsJWiO0MGg
jGEbP0fc08QLLH9cflrxnSFCXjXV4jBwUtaTKIJ2YRrPS5bS2gKGZ/8XJtijJj8Z
7UEsu0gm1f7BCxy5+iGztgYynZeSLr6ggo7zKjd+zYfhUxb8KpbeJphU3NHhazBA
eMebRNZIFrOzZxMtCVuNFmHMMuO88H3QkygK23RrugVOomwVBbqFoFlo7Y1/2yJ1
uQENBFBIw1kBCADXeJdUQUozDeZcUydM/uB5sYbAJ3FtaMJlpGC/vVtIDQjgj8Yg
Tqb+md52iq2kvyuXYjd3wF0fptCZOgGmENCo7jGFNEYfLUEIZ7bxbT7TXYvHXDaU
5nP60O9lqNan+wM4U4R4EXh0EvV+8lvVr+SpYXY/jLReb+FFuJu5+koAGsAGHPoS
DgyxTE7VnzXPBSg5GpKCdLTYOuZq3er6z2qpTpmk+jFMjYat/4g1AEKpaaEWAc3J
kbpvcGcaaslaRHmXqDv/8fqQd6tub0yPwzMV9yZVyK6scL20NdLhOaXr5jGNdE8P
VsgISpV+ow3f9ojw3ZTYtgbLgAubX0mml1DTABEBAAGJASUEGAECAA8FAlBIw1kC
GwwFCQlmAYAACgkQpnvm6waFHzinZwf/QLG3f/LS1LMpdZvhLOvW+YIsA34jwAv7
jLZh2vwxAKXXMMnXSRgSGAlLeE4abvLylaJp0KD4R9QAv4FVV9tkkZA8+cFyKy6l
fl6tZBN7uUGcmiJar6eBzra+1QuEZ8VO9g9jGaxANKStpW+W2KotboUZcNzcRDUR
gUFiRXXOtFqeMnLlpwd8/94YCI15leeWgSE3a/yg6mDQg6O4rmb8T8mSSC9jm5dw
jR+rTVvsl2s65qa7+7J2E7axxfztIJV/Eyj3Ao7mt86KpfTFo02vEoy+IPGEhEwO
Ms4YRTYkCVDumByEf8R9rSUzsv35y9u1glSuiNiu4e82/TAmCd5qcg==
=KoZw
-----END PGP PUBLIC KEY BLOCK-----

--------------090304010102010701010904--
