Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f174.google.com ([209.85.208.174]:33947 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeGaCVh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 22:21:37 -0400
Received: by mail-lj1-f174.google.com with SMTP id f8-v6so12156485ljk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 17:44:01 -0700 (PDT)
MIME-Version: 1.0
From: Sterling Windmill <swindmill@gmail.com>
Date: Mon, 30 Jul 2018 20:43:47 -0400
Message-ID: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
Subject: csum failed on raid1 even after clean scrub?
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000b092cf057240dfc9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--000000000000b092cf057240dfc9
Content-Type: text/plain; charset="UTF-8"

I am using a two disk raid1 btrfs filesystem spanning two external hard
drives connected via USB 3.0.

While copying ~6TB of data from this filesystem to local disk via rsync I
am seeing messages like the following in dmesg output:

[ 2213.406267] BTRFS warning (device sdj1): csum failed root 5 ino 830 off
2124197888 csum 0xb5da0cd2 expected csum 0x6e478250 mirror 2
[ 4890.178727] BTRFS warning (device sdj1): csum failed root 5 ino 1058 off
26052067328 csum 0x8ccd1067 expected csum 0x4adb8254 mirror 2
[27463.940218] BTRFS warning (device sdj1): csum failed root 5 ino 5372 off
7954096128 csum 0x9f9b697e expected csum 0xbd61a0e2 mirror 2
[29405.832643] BTRFS warning (device sdj1): csum failed root 5 ino 31374
off 7893983232 csum 0x12fd0ddc expected csum 0xddcd2f8e mirror 2
[31224.279082] BTRFS warning (device sdj1): csum failed root 5 ino 150903
off 183635968 csum 0xea025eb4 expected csum 0x46d64878 mirror 2
[32282.635615] BTRFS warning (device sdj1): csum failed root 5 ino 162774
off 31092424704 csum 0x1ee9b38d expected csum 0x4022e3de mirror 2
[41052.643493] BTRFS warning (device sdj1): csum failed root 5 ino 163742
off 52214816768 csum 0x6723208c expected csum 0x0377e68a mirror 2
[47723.500430] BTRFS warning (device sdj1): csum failed root 5 ino 470775
off 12533760 csum 0x9f50f9a0 expected csum 0x23ddc68e mirror 2
[60060.843425] BTRFS warning (device sdj1): csum failed root 5 ino 786762
off 4178321408 csum 0xcd520ead expected csum 0x46fe6ebc mirror 2
[60900.058745] BTRFS warning (device sdj1): csum failed root 5 ino 786900
off 896303104 csum 0x4c7e26e7 expected csum 0x86554095 mirror 2
[68149.417236] BTRFS warning (device sdj1): csum failed root 5 ino 1058 off
3101224960 csum 0x2b8c363c expected csum 0x8df2991a mirror 1
[69072.272010] BTRFS warning (device sdj1): csum failed root 5 ino 1141 off
2939588608 csum 0xa2969f63 expected csum 0xddf33efd mirror 1
[71342.354453] BTRFS warning (device sdj1): csum failed root 5 ino 1328 off
57047568384 csum 0xd57f5bb7 expected csum 0x421f96e5 mirror 1

Because the device was consistent, it seemed that one of the disks held bad
data. I wasn't sure if btrfs was correcting the issue by using the other
seemingly good copy on the second disk or if I was copying bad data to the
destination filesystem, so I aborted the copy and ran a scrub of the
filesystem that includes sdj1 by issuing the following command:

btrfs scrub start /external

I let the scrub finish and monitored the result using the following command:

btrfs scrub status /external

Which showed the following output:

scrub status for ece518d2-4af0-4ef7-a31d-8c89b13a5ad9
        scrub started at Sun Jul 29 11:34:44 2018 and finished after
14:34:58
        total bytes scrubbed: 12.80TiB with 0 errors

Alright, perhaps btrfs had already fixed the issues upon encountering them.
I ran my copy again only to see very similar messages show up in dmesg:

[154842.551604] BTRFS warning (device sdj1): csum failed root 5 ino 1284
off 858886144 csum 0x8caf203c expected csum 0x9a3acab6 mirror 2
[159949.727412] BTRFS warning (device sdj1): csum failed root 5 ino 1636
off 4463370240 csum 0x8dfaf00c expected csum 0xa7ab457e mirror 2
[160911.893913] BTRFS warning (device sdj1): csum failed root 5 ino 1729
off 8181428224 csum 0xd57845b5 expected csum 0x6904c54e mirror 2
[165210.245890] BTRFS warning (device sdj1): csum failed root 5 ino 2927
off 1013219328 csum 0xf2d2820d expected csum 0x812222bb mirror 2
[169279.620570] BTRFS warning (device sdj1): csum failed root 5 ino 3363
off 900493312 csum 0x6c6a35a2 expected csum 0x2a983a9c mirror 2
[169990.401373] BTRFS warning (device sdj1): csum failed root 5 ino 4277
off 186707968 csum 0xbdd075d5 expected csum 0xf302e9df mirror 2
[171411.085425] BTRFS warning (device sdj1): csum failed root 5 ino 4719
off 593842176 csum 0xcdabc7e6 expected csum 0xc137d47a mirror 2
[173370.025471] BTRFS warning (device sdj1): csum failed root 5 ino 5267
off 2605592576 csum 0xcd2cb8a8 expected csum 0x9de364e9 mirror 2
[180329.942125] BTRFS warning (device sdj1): csum failed root 5 ino 162774
off 22459506688 csum 0xc38e7a53 expected csum 0xad11854c mirror 2

I would have expected the scrub to find these issues or to show some number
of corrected errors. Perhaps I misunderstand what scrub does?

I also tried tracking down individual files via the referenced inode
numbers with the following command:

btrfs inspect-internal inode-resolve $INODE /external

And ran checksums of the source and destination versions of these files to
find them to be identical. So at least the copy on the source and
destination appear to match.

Maybe I'm experiencing some sort of intermittent USB device / bus issue?
Can anyone help explain what might be happening here?

Thanks!

--000000000000b092cf057240dfc9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I am using a two disk raid1 btrfs filesystem spanning two =
external hard drives connected via USB 3.0.<div><br></div><div>While copyin=
g ~6TB of data from this filesystem to local disk via rsync I am seeing mes=
sages like the following in dmesg output:</div><div><br></div><div><div>[ 2=
213.406267] BTRFS warning (device sdj1): csum failed root 5 ino 830 off 212=
4197888 csum 0xb5da0cd2 expected csum 0x6e478250 mirror 2</div><div>[ 4890.=
178727] BTRFS warning (device sdj1): csum failed root 5 ino 1058 off 260520=
67328 csum 0x8ccd1067 expected csum 0x4adb8254 mirror 2</div><div>[27463.94=
0218] BTRFS warning (device sdj1): csum failed root 5 ino 5372 off 79540961=
28 csum 0x9f9b697e expected csum 0xbd61a0e2 mirror 2</div><div>[29405.83264=
3] BTRFS warning (device sdj1): csum failed root 5 ino 31374 off 7893983232=
 csum 0x12fd0ddc expected csum 0xddcd2f8e mirror 2</div><div>[31224.279082]=
 BTRFS warning (device sdj1): csum failed root 5 ino 150903 off 183635968 c=
sum 0xea025eb4 expected csum 0x46d64878 mirror 2</div><div>[32282.635615] B=
TRFS warning (device sdj1): csum failed root 5 ino 162774 off 31092424704 c=
sum 0x1ee9b38d expected csum 0x4022e3de mirror 2</div><div>[41052.643493] B=
TRFS warning (device sdj1): csum failed root 5 ino 163742 off 52214816768 c=
sum 0x6723208c expected csum 0x0377e68a mirror 2</div><div>[47723.500430] B=
TRFS warning (device sdj1): csum failed root 5 ino 470775 off 12533760 csum=
 0x9f50f9a0 expected csum 0x23ddc68e mirror 2</div><div>[60060.843425] BTRF=
S warning (device sdj1): csum failed root 5 ino 786762 off 4178321408 csum =
0xcd520ead expected csum 0x46fe6ebc mirror 2</div><div>[60900.058745] BTRFS=
 warning (device sdj1): csum failed root 5 ino 786900 off 896303104 csum 0x=
4c7e26e7 expected csum 0x86554095 mirror 2</div><div>[68149.417236] BTRFS w=
arning (device sdj1): csum failed root 5 ino 1058 off 3101224960 csum 0x2b8=
c363c expected csum 0x8df2991a mirror 1</div><div>[69072.272010] BTRFS warn=
ing (device sdj1): csum failed root 5 ino 1141 off 2939588608 csum 0xa2969f=
63 expected csum 0xddf33efd mirror 1</div><div>[71342.354453] BTRFS warning=
 (device sdj1): csum failed root 5 ino 1328 off 57047568384 csum 0xd57f5bb7=
 expected csum 0x421f96e5 mirror 1</div></div><div><br></div><div>Because t=
he device was consistent, it seemed that one of the disks held bad data. I =
wasn&#39;t sure if btrfs was correcting the issue by using the other seemin=
gly good copy on the second disk or if I was copying bad data to the destin=
ation filesystem, so I aborted the copy and ran a scrub of the filesystem t=
hat includes sdj1 by issuing the following command:</div><div><br></div><di=
v>btrfs scrub start /external<br></div><div><br></div><div>I let the scrub =
finish and monitored the result using the following command:</div><div><br>=
</div><div>btrfs scrub status /external</div><div><br></div><div>Which show=
ed the following output:</div><div><br></div><div><div>scrub status for ece=
518d2-4af0-4ef7-a31d-8c89b13a5ad9</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 scr=
ub started at Sun Jul 29 11:34:44 2018 and finished after 14:34:58</div><di=
v>=C2=A0 =C2=A0 =C2=A0 =C2=A0 total bytes scrubbed: 12.80TiB with 0 errors<=
/div></div><div><br></div><div>Alright, perhaps btrfs had already fixed the=
 issues upon encountering them. I ran my copy again only to see very simila=
r messages show up in dmesg:</div><div><br></div><div>

<div style=3D"font-size:small;background-color:rgb(255,255,255);text-decora=
tion-style:initial;text-decoration-color:initial">[154842.551604] BTRFS war=
ning (device sdj1): csum failed root 5 ino 1284 off 858886144 csum 0x8caf20=
3c expected csum 0x9a3acab6 mirror 2</div><div style=3D"font-size:small;bac=
kground-color:rgb(255,255,255);text-decoration-style:initial;text-decoratio=
n-color:initial">[159949.727412] BTRFS warning (device sdj1): csum failed r=
oot 5 ino 1636 off 4463370240 csum 0x8dfaf00c expected csum 0xa7ab457e mirr=
or 2</div><div style=3D"font-size:small;background-color:rgb(255,255,255);t=
ext-decoration-style:initial;text-decoration-color:initial">[160911.893913]=
 BTRFS warning (device sdj1): csum failed root 5 ino 1729 off 8181428224 cs=
um 0xd57845b5 expected csum 0x6904c54e mirror 2</div><div style=3D"font-siz=
e:small;background-color:rgb(255,255,255);text-decoration-style:initial;tex=
t-decoration-color:initial">[165210.245890] BTRFS warning (device sdj1): cs=
um failed root 5 ino 2927 off 1013219328 csum 0xf2d2820d expected csum 0x81=
2222bb mirror 2</div><div style=3D"font-size:small;background-color:rgb(255=
,255,255);text-decoration-style:initial;text-decoration-color:initial">[169=
279.620570] BTRFS warning (device sdj1): csum failed root 5 ino 3363 off 90=
0493312 csum 0x6c6a35a2 expected csum 0x2a983a9c mirror 2</div><div style=
=3D"font-size:small;background-color:rgb(255,255,255);text-decoration-style=
:initial;text-decoration-color:initial">[169990.401373] BTRFS warning (devi=
ce sdj1): csum failed root 5 ino 4277 off 186707968 csum 0xbdd075d5 expecte=
d csum 0xf302e9df mirror 2</div><div style=3D"font-size:small;background-co=
lor:rgb(255,255,255);text-decoration-style:initial;text-decoration-color:in=
itial">[171411.085425] BTRFS warning (device sdj1): csum failed root 5 ino =
4719 off 593842176 csum 0xcdabc7e6 expected csum 0xc137d47a mirror 2</div><=
div style=3D"font-size:small;background-color:rgb(255,255,255);text-decorat=
ion-style:initial;text-decoration-color:initial">[173370.025471] BTRFS warn=
ing (device sdj1): csum failed root 5 ino 5267 off 2605592576 csum 0xcd2cb8=
a8 expected csum 0x9de364e9 mirror 2</div><div style=3D"font-size:small;bac=
kground-color:rgb(255,255,255);text-decoration-style:initial;text-decoratio=
n-color:initial">[180329.942125] BTRFS warning (device sdj1): csum failed r=
oot 5 ino 162774 off 22459506688 csum 0xc38e7a53 expected csum 0xad11854c m=
irror 2</div>

<br></div><div>I would have expected the scrub to find these issues or to s=
how some number of corrected errors. Perhaps I misunderstand what scrub doe=
s?</div><div><br></div><div>I also tried tracking down individual files via=
 the referenced inode numbers with the following command:</div><div><br></d=
iv><div>btrfs inspect-internal inode-resolve $INODE /external<br></div><div=
><br></div><div>And ran checksums of the source and destination versions of=
 these files to find them to be identical. So at least the copy on the sour=
ce and destination appear to match.</div><div><br></div><div>Maybe I&#39;m =
experiencing some sort of intermittent USB device / bus issue? Can anyone h=
elp explain what might be happening here?</div><div><br></div><div>Thanks!<=
/div><div><br></div><div><br></div><div><br></div><div><br></div></div>

--000000000000b092cf057240dfc9--
