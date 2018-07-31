Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:35634 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbeGaUVk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 16:21:40 -0400
Received: by mail-ua0-f181.google.com with SMTP id q12-v6so10972657ual.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 11:40:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
References: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 31 Jul 2018 21:40:03 +0300
Message-ID: <CAN4oSBdnvnfJRJHz5XzN-d+PY3Ap+cR22Ptu1RbPyJMggUPjog@mail.gmail.com>
Subject: Re: Expected Received UUID
To: Gaurav Sanghavi <gaurav.ms5@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000000506c05724fe8ca"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--00000000000000506c05724fe8ca
Content-Type: text/plain; charset="UTF-8"

Not an answer, but exactly same case:
https://unix.stackexchange.com/questions/377914/how-to-test-if-two-btrfs-snapshots-are-identical

2018-07-31 20:42 GMT+03:00 Gaurav Sanghavi <gaurav.ms5@gmail.com>:

> Hello everyone,
>
> While researching BTRFS for a project that involves backing up snapshots
> from device A to device B
> before consolidating backups from device B to device C, I noticed that
> received UUID on snapshot on
> device C is not the same as received UUID for the same snapshot on device
> B. Here are my steps:
>
> 1. Device A
> BTRFS version: v3.17
>
> btrfs su sn -r /home/test/snapshot1 /home/test/snaps/snapshot1
> btrfs su show /home/test/snaps/snapshot1
> Name: snapshot1
> uuid: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> Parent uuid: cb570dec-e9fd-1f40-99d2-2070c8ee2466
>         Received UUID:      ---
> Creation time: 2018-07-30 18:32:37
> Flags: readonly
>
> 2. Send to Device B
> btrfs send /home/test/snaps/snapshot1 | ssh <device b> 'btrfs receive
> /home/backups/'
>
> After send completes, on Device B
> BTRFS version: v4.7.3
> btrfs su show /home/backups/snapshot1
> Name: snapshot1
> UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> Parent UUID: a2314f7c-4b11-ed40-901f-f1acb5ebf802
> Received UUID: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> Creation time: 2018-07-30 18:42:37 -0700
> Flags: readonly
>
>
> 3. Send to Device C
> btrfs send /home/backups/snapshot1 | ssh <device c> 'btrfs receive
> /home/backups2/'
>
> After send completes, on Device C
> BTRFS version: v4.7.3
> btrfs su show /home/backups2/snapshot1
> Name: snapshot1
> UUID: 8a13aab5-8e44-2541-9082-bc583933b964
> Parent UUID: 54e9b4ff-46dc-534e-b70f-69eb7bb21028
> Received UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> Creation time: 2018-07-30 18:58:32 -0700
> Flags: readonly
>
> 1. I have gone through some of the archived emails and have noticed people
> mentioning that
> if received UUID is set, btrfs send propogates this 'received UUID'. But
> in above case,
> it's different for the same snapshot on all three devices. Is this the
> expected behavior ?
>
> 2. We want to be able to start backing up from Device A to C, in case B
> goes down or needs
> to be replaced. If received UUID is expected to differ for the snapshot on
> device B and C, incremental
> backups will not work from A to C without setting received UUID. I have
> seen python-btrfs
> mentioned in a couple of emails; but have anyone of you used it in a
> production environment ?
>
> This is my first post to this email. Please let me know if I am missing
> any details.
>
> Thanks,
> Gaurav
>
>

--00000000000000506c05724fe8ca
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Not an answer, but exactly same case:=C2=A0<a href=3D"http=
s://unix.stackexchange.com/questions/377914/how-to-test-if-two-btrfs-snapsh=
ots-are-identical">https://unix.stackexchange.com/questions/377914/how-to-t=
est-if-two-btrfs-snapshots-are-identical</a></div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">2018-07-31 20:42 GMT+03:00 Gaurav Sanghavi=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:gaurav.ms5@gmail.com" target=3D"_b=
lank">gaurav.ms5@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><div dir=3D"ltr">Hello everyone,=C2=A0<div><br></div><div>While researchi=
ng BTRFS for a project that involves backing up snapshots from device A to =
device B=C2=A0</div><div>before consolidating backups from device B to devi=
ce C, I noticed that received UUID on snapshot on=C2=A0</div><div>device C =
is not the same as received UUID for the same snapshot on device B. Here ar=
e my steps:</div><div><br></div><div>1. Device A</div><div>BTRFS version: v=
3.17<br></div><div><br></div><div>btrfs su sn -r /home/test/snapshot1 /home=
/test/snaps/snapshot1</div><div>btrfs su show /home/test/snaps/snapshot1<br=
></div><div><div><span style=3D"white-space:pre-wrap">	</span>Name: <span s=
tyle=3D"white-space:pre-wrap">			</span>snapshot1</div><div><span style=3D"=
white-space:pre-wrap">	</span>uuid: <span style=3D"white-space:pre-wrap">		=
	</span>b00e8ba1-5aaa-3641-9c4c-<wbr>e168eee5c296</div><div><span style=3D"=
white-space:pre-wrap">	</span>Parent uuid: <span style=3D"white-space:pre-w=
rap">		</span>cb570dec-e9fd-1f40-99d2-<wbr>2070c8ee2466</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 Received UUID:=C2=A0 =C2=A0 =C2=A0 ---</div><div><span=
 style=3D"white-space:pre-wrap">	</span>Creation time: <span style=3D"white=
-space:pre-wrap">		</span>2018-07-30 18:32:37</div><div><span style=3D"whit=
e-space:pre-wrap">	</span>Flags: <span style=3D"white-space:pre-wrap">			</=
span>readonly</div></div><div><br></div><div>2. Send to Device B</div><div>=
btrfs send /home/test/snaps/snapshot1 | ssh &lt;device b&gt; &#39;btrfs rec=
eive /home/backups/&#39;<br></div><div><br></div><div>After send completes,=
 on Device B</div><div>BTRFS version: v4.7.3</div><div>btrfs su show /home/=
backups/snapshot1</div><div><div><span style=3D"white-space:pre-wrap">	</sp=
an>Name: <span style=3D"white-space:pre-wrap">			</span>snapshot1</div><div=
><span style=3D"white-space:pre-wrap">	</span>UUID: <span style=3D"white-sp=
ace:pre-wrap">			</span>7c13d189-7fee-584e-ac90-<wbr>e68cb0012f5c</div><div=
><span style=3D"white-space:pre-wrap">	</span>Parent UUID: <span style=3D"w=
hite-space:pre-wrap">		</span>a2314f7c-4b11-ed40-901f-<wbr>f1acb5ebf802</di=
v><div><span style=3D"white-space:pre-wrap">	</span>Received UUID: <span st=
yle=3D"white-space:pre-wrap">	</span>b00e8ba1-5aaa-3641-9c4c-<wbr>e168eee5c=
296</div><div><span style=3D"white-space:pre-wrap">	</span>Creation time: <=
span style=3D"white-space:pre-wrap">		</span>2018-07-30 18:42:37 -0700</div=
><div><span style=3D"white-space:pre-wrap">	</span>Flags: <span style=3D"wh=
ite-space:pre-wrap">			</span>readonly</div></div><div><br></div><div><br><=
/div><div>3. Send to Device C</div><div>btrfs send /home/backups/snapshot1 =
| ssh &lt;device c&gt; &#39;btrfs receive /home/backups2/&#39;</div><div><b=
r></div><div>After send completes, on Device C</div><div>BTRFS version: v4.=
7.3</div><div><span style=3D"font-size:small;background-color:rgb(255,255,2=
55);text-decoration-style:initial;text-decoration-color:initial;float:none;=
display:inline">btrfs su show /home/backups2/snapshot1</span><br></div><div=
><span style=3D"background-color:rgb(255,255,255);text-decoration-style:ini=
tial;text-decoration-color:initial;float:none;display:inline"><div><span st=
yle=3D"white-space:pre-wrap">	</span>Name: <span style=3D"white-space:pre-w=
rap">			</span>snapshot1</div><div><span style=3D"white-space:pre-wrap">	</=
span>UUID: <span style=3D"white-space:pre-wrap">			</span>8a13aab5-8e44-254=
1-9082-<wbr>bc583933b964</div><div><span style=3D"white-space:pre-wrap">	</=
span>Parent UUID: <span style=3D"white-space:pre-wrap">		</span>54e9b4ff-46=
dc-534e-b70f-<wbr>69eb7bb21028</div><div><span style=3D"white-space:pre-wra=
p">	</span>Received UUID: <span style=3D"white-space:pre-wrap">	</span>7c13=
d189-7fee-584e-ac90-<wbr>e68cb0012f5c</div><div><span style=3D"white-space:=
pre-wrap">	</span>Creation time: <span style=3D"white-space:pre-wrap">		</s=
pan>2018-07-30 18:58:32 -0700</div><div><span style=3D"white-space:pre-wrap=
">	</span>Flags: <span style=3D"white-space:pre-wrap">			</span>readonly</d=
iv></span></div><div><br></div><div>1. I have gone through some of the arch=
ived emails and have noticed people mentioning that</div><div>if received U=
UID is set, btrfs send propogates this &#39;received UUID&#39;. But in abov=
e case,=C2=A0</div><div>it&#39;s different for the same snapshot on all thr=
ee devices. Is this the expected behavior ?</div><div><br></div><div>2. We =
want to be able to start backing up from Device A to C, in case B goes down=
 or needs=C2=A0</div><div>to be replaced. If received UUID is expected to d=
iffer for the snapshot on device B and C, incremental</div><div>backups wil=
l not work from A to C without setting received UUID. I have seen python-bt=
rfs</div><div>mentioned in a couple of emails; but have anyone of you used =
it in a production environment ?</div><div><br></div><div>This is my first =
post to this email. Please let me know if I am missing any details.</div><d=
iv><br></div><div>Thanks,</div><div>Gaurav</div><div><br></div></div>
</blockquote></div><br></div>

--00000000000000506c05724fe8ca--
