Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43928 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbeGaCot (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 22:44:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id r13-v6so12179364ljg.10
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 18:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
 <09e9001a-b624-cc78-eee5-3dd139eb02bc@gmx.com>
In-Reply-To: <09e9001a-b624-cc78-eee5-3dd139eb02bc@gmx.com>
From: Sterling Windmill <swindmill@gmail.com>
Date: Mon, 30 Jul 2018 21:06:54 -0400
Message-ID: <CAMOu_z0d+CB3JXBgwXtj2gZGTdtCjKOZNHEuB43DxXprubKW=w@mail.gmail.com>
Subject: Re: csum failed on raid1 even after clean scrub?
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000005f135705724132c0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--0000000000005f135705724132c0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 Thanks for the speedy reply!

Here's my kernel version:

4.17.9-200.fc28.x86_64

dmesg doesn't show any USB related info at all, no signs of errors /
warnings.

Both drives are identical, Seagate 8TB external drives connected to the
following PCIe controller:

03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller
(rev 03)

lsusb output:

Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 005: ID 0bc2:ab38 Seagate RSS LLC Backup Plus Hub
Bus 004 Device 003: ID 0bc2:ab45 Seagate RSS LLC
Bus 004 Device 004: ID 0bc2:ab38 Seagate RSS LLC Backup Plus Hub
Bus 004 Device 002: ID 0bc2:ab45 Seagate RSS LLC
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 0bc2:ab44 Seagate RSS LLC
Bus 003 Device 002: ID 0bc2:ab44 Seagate RSS LLC
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0624:0248 Avocent Corp. Virtual Hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

There's no output in dmesg related to the scrub, only the few csum failed
messages I included in my last email.

Per your request, I'm starting a scrub on the single device with the
following command:

btrfs scrub start /dev/sdj1
scrub started on /dev/sdj1, fsid ece518d2-4af0-4ef7-a31d-8c89b13a5ad9
(pid=3D14684)

I'll report back once this is complete. Anything else I can collect that
might be helpful in understanding what's happening here?


On Mon, Jul 30, 2018 at 8:56 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
>
> On 2018=E5=B9=B407=E6=9C=8831=E6=97=A5 08:43, Sterling Windmill wrote:
> > I am using a two disk raid1 btrfs filesystem spanning two external hard
> > drives connected via USB 3.0.
>
> Is there any speed difference between the two device?
> And are these 2 devices under the same USB3.0 root hub or different root
> hubs?
>
> lsusb output could help to determine the hierarchy.
>
> >
> > While copying ~6TB of data from this filesystem to local disk via rsync
> > I am seeing messages like the following in dmesg output:
> >
> > [ 2213.406267] BTRFS warning (device sdj1): csum failed root 5 ino 830
> > off 2124197888 csum 0xb5da0cd2 expected csum 0x6e478250 mirror 2
>
> Since only one copy shows the problem, the other copy should be good
> thus the read should work without problem.
>
> > [ 4890.178727] BTRFS warning (device sdj1): csum failed root 5 ino 1058
> > off 26052067328 csum 0x8ccd1067 expected csum 0x4adb8254 mirror 2
> > [27463.940218] BTRFS warning (device sdj1): csum failed root 5 ino 5372
> > off 7954096128 csum 0x9f9b697e expected csum 0xbd61a0e2 mirror 2
> > [29405.832643] BTRFS warning (device sdj1): csum failed root 5 ino 3137=
4
> > off 7893983232 csum 0x12fd0ddc expected csum 0xddcd2f8e mirror 2
> > [31224.279082] BTRFS warning (device sdj1): csum failed root 5 ino
> > 150903 off 183635968 csum 0xea025eb4 expected csum 0x46d64878 mirror 2
> > [32282.635615] BTRFS warning (device sdj1): csum failed root 5 ino
> > 162774 off 31092424704 csum 0x1ee9b38d expected csum 0x4022e3de mirror =
2
> > [41052.643493] BTRFS warning (device sdj1): csum failed root 5 ino
> > 163742 off 52214816768 csum 0x6723208c expected csum 0x0377e68a mirror =
2
> > [47723.500430] BTRFS warning (device sdj1): csum failed root 5 ino
> > 470775 off 12533760 csum 0x9f50f9a0 expected csum 0x23ddc68e mirror 2
> > [60060.843425] BTRFS warning (device sdj1): csum failed root 5 ino
> > 786762 off 4178321408 csum 0xcd520ead expected csum 0x46fe6ebc mirror 2
> > [60900.058745] BTRFS warning (device sdj1): csum failed root 5 ino
> > 786900 off 896303104 csum 0x4c7e26e7 expected csum 0x86554095 mirror 2
> > [68149.417236] BTRFS warning (device sdj1): csum failed root 5 ino 1058
> > off 3101224960 csum 0x2b8c363c expected csum 0x8df2991a mirror 1
> > [69072.272010] BTRFS warning (device sdj1): csum failed root 5 ino 1141
> > off 2939588608 csum 0xa2969f63 expected csum 0xddf33efd mirror 1
> > [71342.354453] BTRFS warning (device sdj1): csum failed root 5 ino 1328
> > off 57047568384 csum 0xd57f5bb7 expected csum 0x421f96e5 mirror 1
> >
> > Because the device was consistent, it seemed that one of the disks held
> > bad data. I wasn't sure if btrfs was correcting the issue by using the
> > other seemingly good copy on the second disk or if I was copying bad
> > data to the destination filesystem, so I aborted the copy and ran a
> > scrub of the filesystem that includes sdj1 by issuing the following
> command:
> >
> > btrfs scrub start /external
> >
> > I let the scrub finish and monitored the result using the following
> command:
> >
> > btrfs scrub status /external
> >
> > Which showed the following output:
> >
> > scrub status for ece518d2-4af0-4ef7-a31d-8c89b13a5ad9
> >         scrub started at Sun Jul 29 11:34:44 2018 and finished after
> > 14:34:58
> >         total bytes scrubbed: 12.80TiB with 0 errors
>
> Would you provide the dmesg during the scrub?
>
> >
> > Alright, perhaps btrfs had already fixed the issues upon encountering
> > them. I ran my copy again only to see very similar messages show up in
> > dmesg:
> >
> > [154842.551604] BTRFS warning (device sdj1): csum failed root 5 ino 128=
4
> > off 858886144 csum 0x8caf203c expected csum 0x9a3acab6 mirror 2
>
> At least the corrupted ino and offset is different, thus the old
> corruption is fixed, but somehow it introduced new corruption.
>
> > [159949.727412] BTRFS warning (device sdj1): csum failed root 5 ino 163=
6
> > off 4463370240 csum 0x8dfaf00c expected csum 0xa7ab457e mirror 2
> > [160911.893913] BTRFS warning (device sdj1): csum failed root 5 ino 172=
9
> > off 8181428224 csum 0xd57845b5 expected csum 0x6904c54e mirror 2
> > [165210.245890] BTRFS warning (device sdj1): csum failed root 5 ino 292=
7
> > off 1013219328 csum 0xf2d2820d expected csum 0x812222bb mirror 2
> > [169279.620570] BTRFS warning (device sdj1): csum failed root 5 ino 336=
3
> > off 900493312 csum 0x6c6a35a2 expected csum 0x2a983a9c mirror 2
> > [169990.401373] BTRFS warning (device sdj1): csum failed root 5 ino 427=
7
> > off 186707968 csum 0xbdd075d5 expected csum 0xf302e9df mirror 2
> > [171411.085425] BTRFS warning (device sdj1): csum failed root 5 ino 471=
9
> > off 593842176 csum 0xcdabc7e6 expected csum 0xc137d47a mirror 2
> > [173370.025471] BTRFS warning (device sdj1): csum failed root 5 ino 526=
7
> > off 2605592576 csum 0xcd2cb8a8 expected csum 0x9de364e9 mirror 2
> > [180329.942125] BTRFS warning (device sdj1): csum failed root 5 ino
> > 162774 off 22459506688 csum 0xc38e7a53 expected csum 0xad11854c mirror =
2
>
> Since all corruption showed above is about mirror 2, would you mind to
> try scrub certain device other than the whole fs and attach the dmesg?
>
> # btrfs scrub start <device>
>
>
>
> >
> > I would have expected the scrub to find these issues or to show some
> > number of corrected errors. Perhaps I misunderstand what scrub does?
>
> Your understanding is completely correct.
> In fact reading from corrupted block should trigger re-write on
> corrupted data.
>
> I'm wondering if it's related to some scrub race, since for multi-device
> btrfs, full fs scrub is addressed by doing multiple scrub
> simultaneously, one scrub for each device.
> It used to cause problem for raid5/6, but never heard of corruption for
> raid1.
>
> Would you provide the kernel version and full dmesg (including reading
> error and scrub, and later read)?
>
> >
> > I also tried tracking down individual files via the referenced inode
> > numbers with the following command:
> >
> > btrfs inspect-internal inode-resolve $INODE /external
> >
> > And ran checksums of the source and destination versions of these files
> > to find them to be identical. So at least the copy on the source and
> > destination appear to match.
>
> Since btrfs will switch to the good copy, the data should be correct.
>
> >
> > Maybe I'm experiencing some sort of intermittent USB device / bus issue=
?
>
> Full dmesg may help, if there is something related to usb.
>
> Thanks,
> Qu
>
> > Can anyone help explain what might be happening here?
> >
> > Thanks!
> >
> >
> >
> >
>
>

--0000000000005f135705724132c0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">

<span style=3D"font-size:small;text-decoration-style:initial;text-decoratio=
n-color:initial;float:none;display:inline">Thanks for the speedy reply!</sp=
an><div style=3D"font-size:small;text-decoration-style:initial;text-decorat=
ion-color:initial"><br></div><div style=3D"font-size:small;text-decoration-=
style:initial;text-decoration-color:initial">Here&#39;s my kernel version:<=
/div><div style=3D"font-size:small;text-decoration-style:initial;text-decor=
ation-color:initial"><br></div><div style=3D"font-size:small;text-decoratio=
n-style:initial;text-decoration-color:initial">4.17.9-200.fc28.x86_64<br></=
div><div style=3D"font-size:small;text-decoration-style:initial;text-decora=
tion-color:initial"><br></div><div style=3D"font-size:small;text-decoration=
-style:initial;text-decoration-color:initial">dmesg doesn&#39;t show any US=
B related info at all, no signs of errors / warnings.</div><div style=3D"fo=
nt-size:small;text-decoration-style:initial;text-decoration-color:initial">=
<br></div><div style=3D"font-size:small;text-decoration-style:initial;text-=
decoration-color:initial">Both drives are identical, Seagate 8TB external d=
rives connected to the following PCIe controller:</div><div style=3D"font-s=
ize:small;text-decoration-style:initial;text-decoration-color:initial"><br>=
</div><div style=3D"font-size:small;text-decoration-style:initial;text-deco=
ration-color:initial">03:00.0 USB controller: NEC Corporation uPD720200 USB=
 3.0 Host Controller (rev 03)<br></div><div style=3D"font-size:small;text-d=
ecoration-style:initial;text-decoration-color:initial"><br></div><div style=
=3D"font-size:small;text-decoration-style:initial;text-decoration-color:ini=
tial">lsusb output:</div><div style=3D"font-size:small;text-decoration-styl=
e:initial;text-decoration-color:initial"><br></div><div style=3D"font-size:=
small;text-decoration-style:initial;text-decoration-color:initial"><div>Bus=
 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub</div=
><div>Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub</div><=
div>Bus 004 Device 005: ID 0bc2:ab38 Seagate RSS LLC Backup Plus Hub</div><=
div>Bus 004 Device 003: ID 0bc2:ab45 Seagate RSS LLC</div><div>Bus 004 Devi=
ce 004: ID 0bc2:ab38 Seagate RSS LLC Backup Plus Hub</div><div>Bus 004 Devi=
ce 002: ID 0bc2:ab45 Seagate RSS LLC</div><div>Bus 004 Device 001: ID 1d6b:=
0003 Linux Foundation 3.0 root hub</div><div>Bus 003 Device 003: ID 0bc2:ab=
44 Seagate RSS LLC</div><div>Bus 003 Device 002: ID 0bc2:ab44 Seagate RSS L=
LC</div><div>Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub=
</div><div>Bus 001 Device 003: ID 0624:0248 Avocent Corp. Virtual Hub</div>=
<div>Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching =
Hub</div><div>Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hu=
b</div></div><div style=3D"font-size:small;text-decoration-style:initial;te=
xt-decoration-color:initial"><br></div><div style=3D"font-size:small;text-d=
ecoration-style:initial;text-decoration-color:initial">There&#39;s no outpu=
t in dmesg related to the scrub, only the few csum failed messages I includ=
ed in my last email.</div><div style=3D"font-size:small;text-decoration-sty=
le:initial;text-decoration-color:initial"><br></div><div style=3D"font-size=
:small;text-decoration-style:initial;text-decoration-color:initial">Per you=
r request, I&#39;m starting a scrub on the single device with the following=
 command:</div><div style=3D"font-size:small;text-decoration-style:initial;=
text-decoration-color:initial"><br></div><div style=3D"font-size:small;text=
-decoration-style:initial;text-decoration-color:initial"><div>btrfs scrub s=
tart /dev/sdj1</div><div>scrub started on /dev/sdj1, fsid ece518d2-4af0-4ef=
7-a31d-8c89b13a5ad9 (pid=3D14684)</div></div><div style=3D"font-size:small;=
text-decoration-style:initial;text-decoration-color:initial"><br></div><div=
 style=3D"font-size:small;text-decoration-style:initial;text-decoration-col=
or:initial">I&#39;ll report back once this is complete. Anything else I can=
 collect that might be helpful in understanding what&#39;s happening here?<=
/div>

<br></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Mon, Jul 30, 2=
018 at 8:56 PM Qu Wenruo &lt;<a href=3D"mailto:quwenruo.btrfs@gmx.com">quwe=
nruo.btrfs@gmx.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
br>
<br>
On 2018=E5=B9=B407=E6=9C=8831=E6=97=A5 08:43, Sterling Windmill wrote:<br>
&gt; I am using a two disk raid1 btrfs filesystem spanning two external har=
d<br>
&gt; drives connected via USB 3.0.<br>
<br>
Is there any speed difference between the two device?<br>
And are these 2 devices under the same USB3.0 root hub or different root<br=
>
hubs?<br>
<br>
lsusb output could help to determine the hierarchy.<br>
<br>
&gt; <br>
&gt; While copying ~6TB of data from this filesystem to local disk via rsyn=
c<br>
&gt; I am seeing messages like the following in dmesg output:<br>
&gt; <br>
&gt; [ 2213.406267] BTRFS warning (device sdj1): csum failed root 5 ino 830=
<br>
&gt; off 2124197888 csum 0xb5da0cd2 expected csum 0x6e478250 mirror 2<br>
<br>
Since only one copy shows the problem, the other copy should be good<br>
thus the read should work without problem.<br>
<br>
&gt; [ 4890.178727] BTRFS warning (device sdj1): csum failed root 5 ino 105=
8<br>
&gt; off 26052067328 csum 0x8ccd1067 expected csum 0x4adb8254 mirror 2<br>
&gt; [27463.940218] BTRFS warning (device sdj1): csum failed root 5 ino 537=
2<br>
&gt; off 7954096128 csum 0x9f9b697e expected csum 0xbd61a0e2 mirror 2<br>
&gt; [29405.832643] BTRFS warning (device sdj1): csum failed root 5 ino 313=
74<br>
&gt; off 7893983232 csum 0x12fd0ddc expected csum 0xddcd2f8e mirror 2<br>
&gt; [31224.279082] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 150903 off 183635968 csum 0xea025eb4 expected csum 0x46d64878 mirror 2=
<br>
&gt; [32282.635615] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 162774 off 31092424704 csum 0x1ee9b38d expected csum 0x4022e3de mirror=
 2<br>
&gt; [41052.643493] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 163742 off 52214816768 csum 0x6723208c expected csum 0x0377e68a mirror=
 2<br>
&gt; [47723.500430] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 470775 off 12533760 csum 0x9f50f9a0 expected csum 0x23ddc68e mirror 2<=
br>
&gt; [60060.843425] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 786762 off 4178321408 csum 0xcd520ead expected csum 0x46fe6ebc mirror =
2<br>
&gt; [60900.058745] BTRFS warning (device sdj1): csum failed root 5 ino<br>
&gt; 786900 off 896303104 csum 0x4c7e26e7 expected csum 0x86554095 mirror 2=
<br>
&gt; [68149.417236] BTRFS warning (device sdj1): csum failed root 5 ino 105=
8<br>
&gt; off 3101224960 csum 0x2b8c363c expected csum 0x8df2991a mirror 1<br>
&gt; [69072.272010] BTRFS warning (device sdj1): csum failed root 5 ino 114=
1<br>
&gt; off 2939588608 csum 0xa2969f63 expected csum 0xddf33efd mirror 1<br>
&gt; [71342.354453] BTRFS warning (device sdj1): csum failed root 5 ino 132=
8<br>
&gt; off 57047568384 csum 0xd57f5bb7 expected csum 0x421f96e5 mirror 1<br>
&gt; <br>
&gt; Because the device was consistent, it seemed that one of the disks hel=
d<br>
&gt; bad data. I wasn&#39;t sure if btrfs was correcting the issue by using=
 the<br>
&gt; other seemingly good copy on the second disk or if I was copying bad<b=
r>
&gt; data to the destination filesystem, so I aborted the copy and ran a<br=
>
&gt; scrub of the filesystem that includes sdj1 by issuing the following co=
mmand:<br>
&gt; <br>
&gt; btrfs scrub start /external<br>
&gt; <br>
&gt; I let the scrub finish and monitored the result using the following co=
mmand:<br>
&gt; <br>
&gt; btrfs scrub status /external<br>
&gt; <br>
&gt; Which showed the following output:<br>
&gt; <br>
&gt; scrub status for ece518d2-4af0-4ef7-a31d-8c89b13a5ad9<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 scrub started at Sun Jul 29 11:34:44 2018 =
and finished after<br>
&gt; 14:34:58<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 total bytes scrubbed: 12.80TiB with 0 erro=
rs<br>
<br>
Would you provide the dmesg during the scrub?<br>
<br>
&gt; <br>
&gt; Alright, perhaps btrfs had already fixed the issues upon encountering<=
br>
&gt; them. I ran my copy again only to see very similar messages show up in=
<br>
&gt; dmesg:<br>
&gt; <br>
&gt; [154842.551604] BTRFS warning (device sdj1): csum failed root 5 ino 12=
84<br>
&gt; off 858886144 csum 0x8caf203c expected csum 0x9a3acab6 mirror 2<br>
<br>
At least the corrupted ino and offset is different, thus the old<br>
corruption is fixed, but somehow it introduced new corruption.<br>
<br>
&gt; [159949.727412] BTRFS warning (device sdj1): csum failed root 5 ino 16=
36<br>
&gt; off 4463370240 csum 0x8dfaf00c expected csum 0xa7ab457e mirror 2<br>
&gt; [160911.893913] BTRFS warning (device sdj1): csum failed root 5 ino 17=
29<br>
&gt; off 8181428224 csum 0xd57845b5 expected csum 0x6904c54e mirror 2<br>
&gt; [165210.245890] BTRFS warning (device sdj1): csum failed root 5 ino 29=
27<br>
&gt; off 1013219328 csum 0xf2d2820d expected csum 0x812222bb mirror 2<br>
&gt; [169279.620570] BTRFS warning (device sdj1): csum failed root 5 ino 33=
63<br>
&gt; off 900493312 csum 0x6c6a35a2 expected csum 0x2a983a9c mirror 2<br>
&gt; [169990.401373] BTRFS warning (device sdj1): csum failed root 5 ino 42=
77<br>
&gt; off 186707968 csum 0xbdd075d5 expected csum 0xf302e9df mirror 2<br>
&gt; [171411.085425] BTRFS warning (device sdj1): csum failed root 5 ino 47=
19<br>
&gt; off 593842176 csum 0xcdabc7e6 expected csum 0xc137d47a mirror 2<br>
&gt; [173370.025471] BTRFS warning (device sdj1): csum failed root 5 ino 52=
67<br>
&gt; off 2605592576 csum 0xcd2cb8a8 expected csum 0x9de364e9 mirror 2<br>
&gt; [180329.942125] BTRFS warning (device sdj1): csum failed root 5 ino<br=
>
&gt; 162774 off 22459506688 csum 0xc38e7a53 expected csum 0xad11854c mirror=
 2<br>
<br>
Since all corruption showed above is about mirror 2, would you mind to<br>
try scrub certain device other than the whole fs and attach the dmesg?<br>
<br>
# btrfs scrub start &lt;device&gt;<br>
<br>
<br>
<br>
&gt; <br>
&gt; I would have expected the scrub to find these issues or to show some<b=
r>
&gt; number of corrected errors. Perhaps I misunderstand what scrub does?<b=
r>
<br>
Your understanding is completely correct.<br>
In fact reading from corrupted block should trigger re-write on<br>
corrupted data.<br>
<br>
I&#39;m wondering if it&#39;s related to some scrub race, since for multi-d=
evice<br>
btrfs, full fs scrub is addressed by doing multiple scrub<br>
simultaneously, one scrub for each device.<br>
It used to cause problem for raid5/6, but never heard of corruption for<br>
raid1.<br>
<br>
Would you provide the kernel version and full dmesg (including reading<br>
error and scrub, and later read)?<br>
<br>
&gt; <br>
&gt; I also tried tracking down individual files via the referenced inode<b=
r>
&gt; numbers with the following command:<br>
&gt; <br>
&gt; btrfs inspect-internal inode-resolve $INODE /external<br>
&gt; <br>
&gt; And ran checksums of the source and destination versions of these file=
s<br>
&gt; to find them to be identical. So at least the copy on the source and<b=
r>
&gt; destination appear to match.<br>
<br>
Since btrfs will switch to the good copy, the data should be correct.<br>
<br>
&gt; <br>
&gt; Maybe I&#39;m experiencing some sort of intermittent USB device / bus =
issue?<br>
<br>
Full dmesg may help, if there is something related to usb.<br>
<br>
Thanks,<br>
Qu<br>
<br>
&gt; Can anyone help explain what might be happening here?<br>
&gt; <br>
&gt; Thanks!<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; <br>
<br>
</blockquote></div>

--0000000000005f135705724132c0--
