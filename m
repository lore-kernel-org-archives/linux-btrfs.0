Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:52077 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbeHCGuc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 02:50:32 -0400
Received: by mail-wm0-f53.google.com with SMTP id y2-v6so4849559wma.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 21:56:02 -0700 (PDT)
MIME-Version: 1.0
From: Nathan Dehnel <ncdehnel@gmail.com>
Date: Thu, 2 Aug 2018 23:55:50 -0500
Message-ID: <CAEEhgEtHSH2XezqBr_TRmOCDdjq2VdVizMOBmJ2GtHz8FGRnyw@mail.gmail.com>
Subject: btrfs check --repair questions
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000008fdeeb057280be61"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--0000000000008fdeeb057280be61
Content-Type: text/plain; charset="UTF-8"

Question 1: The command has been running for a couple days on a 10TB array
with no visible change in output. Is it actually fixing anything?

enabling repair mode
Checking filesystem on
/dev/disk/by-uuid/e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24
UUID: e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648
root 5 inode 5043370 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 50331648

Question 2: I accidentally interrupted the command by logging out. How
dangerous is this? Should I be worried?

--0000000000008fdeeb057280be61
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Question 1: The command has been running for a couple days=
 on a 10TB array with no visible change in output. Is it actually fixing an=
ything?<div><div><br></div><div>enabling repair mode</div><div>Checking fil=
esystem on /dev/disk/by-uuid/e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24</div><div=
>UUID: e1ee5980-c54b-4b6e-82e2-3dbdcee1dd24</div><div>checking extents</div=
><div>Fixed 0 roots.</div><div>checking free space cache</div><div>cache an=
d super generation don&#39;t match, space cache will be invalidated</div><d=
iv>checking fs roots</div><div>root 5 inode 5043370 errors 100, file extent=
 discount</div><div>Found file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode 5043370 errors 100, =
file extent discount</div><div>Found file extent holes:</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode 5043370=
 errors 100, file extent discount</div><div>Found file extent holes:</div><=
div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 in=
ode 5043370 errors 100, file extent discount</div><div>Found file extent ho=
les:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><di=
v>root 5 inode 5043370 errors 100, file extent discount</div><div>Found fil=
e extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 503316=
48</div><div>root 5 inode 5043370 errors 100, file extent discount</div><di=
v>Found file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, =
len: 50331648</div><div>root 5 inode 5043370 errors 100, file extent discou=
nt</div><div>Found file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 start: 0, len: 50331648</div><div>root 5 inode 5043370 errors 100, file ex=
tent discount</div><div>Found file extent holes:</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode 5043370 errors=
 100, file extent discount</div><div>Found file extent holes:</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode 504=
3370 errors 100, file extent discount</div><div>Found file extent holes:</d=
iv><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root =
5 inode 5043370 errors 100, file extent discount</div><div>Found file exten=
t holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div=
><div>root 5 inode 5043370 errors 100, file extent discount</div><div>Found=
 file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50=
331648</div><div>root 5 inode 5043370 errors 100, file extent discount</div=
><div>Found file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start:=
 0, len: 50331648</div><div>root 5 inode 5043370 errors 100, file extent di=
scount</div><div>Found file extent holes:</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 start: 0, len: 50331648</div><div>root 5 inode 5043370 errors 100, f=
ile extent discount</div><div>Found file extent holes:</div><div>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode 5043370 er=
rors 100, file extent discount</div><div>Found file extent holes:</div><div=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div><div>root 5 inode=
 5043370 errors 100, file extent discount</div><div>Found file extent holes=
:</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 start: 0, len: 50331648</div></div>=
<div><br></div><div>Question 2: I accidentally interrupted the command by l=
ogging out. How dangerous is this? Should I be worried?</div></div>

--0000000000008fdeeb057280be61--
