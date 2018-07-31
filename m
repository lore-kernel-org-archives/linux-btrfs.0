Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:44406 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbeGaTYR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 15:24:17 -0400
Received: by mail-lj1-f177.google.com with SMTP id q127-v6so14443610ljq.11
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 10:42:53 -0700 (PDT)
MIME-Version: 1.0
From: Gaurav Sanghavi <gaurav.ms5@gmail.com>
Date: Tue, 31 Jul 2018 10:42:31 -0700
Message-ID: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
Subject: Expected Received UUID
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000007671f105724f1b1d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--0000000000007671f105724f1b1d
Content-Type: text/plain; charset="UTF-8"

Hello everyone,

While researching BTRFS for a project that involves backing up snapshots
from device A to device B
before consolidating backups from device B to device C, I noticed that
received UUID on snapshot on
device C is not the same as received UUID for the same snapshot on device
B. Here are my steps:

1. Device A
BTRFS version: v3.17

btrfs su sn -r /home/test/snapshot1 /home/test/snaps/snapshot1
btrfs su show /home/test/snaps/snapshot1
Name: snapshot1
uuid: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
Parent uuid: cb570dec-e9fd-1f40-99d2-2070c8ee2466
        Received UUID:      ---
Creation time: 2018-07-30 18:32:37
Flags: readonly

2. Send to Device B
btrfs send /home/test/snaps/snapshot1 | ssh <device b> 'btrfs receive
/home/backups/'

After send completes, on Device B
BTRFS version: v4.7.3
btrfs su show /home/backups/snapshot1
Name: snapshot1
UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
Parent UUID: a2314f7c-4b11-ed40-901f-f1acb5ebf802
Received UUID: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
Creation time: 2018-07-30 18:42:37 -0700
Flags: readonly


3. Send to Device C
btrfs send /home/backups/snapshot1 | ssh <device c> 'btrfs receive
/home/backups2/'

After send completes, on Device C
BTRFS version: v4.7.3
btrfs su show /home/backups2/snapshot1
Name: snapshot1
UUID: 8a13aab5-8e44-2541-9082-bc583933b964
Parent UUID: 54e9b4ff-46dc-534e-b70f-69eb7bb21028
Received UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
Creation time: 2018-07-30 18:58:32 -0700
Flags: readonly

1. I have gone through some of the archived emails and have noticed people
mentioning that
if received UUID is set, btrfs send propogates this 'received UUID'. But in
above case,
it's different for the same snapshot on all three devices. Is this the
expected behavior ?

2. We want to be able to start backing up from Device A to C, in case B
goes down or needs
to be replaced. If received UUID is expected to differ for the snapshot on
device B and C, incremental
backups will not work from A to C without setting received UUID. I have
seen python-btrfs
mentioned in a couple of emails; but have anyone of you used it in a
production environment ?

This is my first post to this email. Please let me know if I am missing any
details.

Thanks,
Gaurav

--0000000000007671f105724f1b1d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello everyone,=C2=A0<div><br></div><div>While researching=
 BTRFS for a project that involves backing up snapshots from device A to de=
vice B=C2=A0</div><div>before consolidating backups from device B to device=
 C, I noticed that received UUID on snapshot on=C2=A0</div><div>device C is=
 not the same as received UUID for the same snapshot on device B. Here are =
my steps:</div><div><br></div><div>1. Device A</div><div>BTRFS version: v3.=
17<br></div><div><br></div><div>btrfs su sn -r /home/test/snapshot1 /home/t=
est/snaps/snapshot1</div><div>btrfs su show /home/test/snaps/snapshot1<br><=
/div><div><div><span style=3D"white-space:pre">	</span>Name: <span style=3D=
"white-space:pre">			</span>snapshot1</div><div><span style=3D"white-space:=
pre">	</span>uuid: <span style=3D"white-space:pre">			</span>b00e8ba1-5aaa-=
3641-9c4c-e168eee5c296</div><div><span style=3D"white-space:pre">	</span>Pa=
rent uuid: <span style=3D"white-space:pre">		</span>cb570dec-e9fd-1f40-99d2=
-2070c8ee2466</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Received UUID:=C2=A0 =
=C2=A0 =C2=A0 ---</div><div><span style=3D"white-space:pre">	</span>Creatio=
n time: <span style=3D"white-space:pre">		</span>2018-07-30 18:32:37</div><=
div><span style=3D"white-space:pre">	</span>Flags: <span style=3D"white-spa=
ce:pre">			</span>readonly</div></div><div><br></div><div>2. Send to Device=
 B</div><div>btrfs send /home/test/snaps/snapshot1 | ssh &lt;device b&gt; &=
#39;btrfs receive /home/backups/&#39;<br></div><div><br></div><div>After se=
nd completes, on Device B</div><div>BTRFS version: v4.7.3</div><div>btrfs s=
u show /home/backups/snapshot1</div><div><div><span style=3D"white-space:pr=
e">	</span>Name: <span style=3D"white-space:pre">			</span>snapshot1</div><=
div><span style=3D"white-space:pre">	</span>UUID: <span style=3D"white-spac=
e:pre">			</span>7c13d189-7fee-584e-ac90-e68cb0012f5c</div><div><span style=
=3D"white-space:pre">	</span>Parent UUID: <span style=3D"white-space:pre">	=
	</span>a2314f7c-4b11-ed40-901f-f1acb5ebf802</div><div><span style=3D"white=
-space:pre">	</span>Received UUID: <span style=3D"white-space:pre">	</span>=
b00e8ba1-5aaa-3641-9c4c-e168eee5c296</div><div><span style=3D"white-space:p=
re">	</span>Creation time: <span style=3D"white-space:pre">		</span>2018-07=
-30 18:42:37 -0700</div><div><span style=3D"white-space:pre">	</span>Flags:=
 <span style=3D"white-space:pre">			</span>readonly</div></div><div><br></d=
iv><div><br></div><div>3. Send to Device C</div><div>btrfs send /home/backu=
ps/snapshot1 | ssh &lt;device c&gt; &#39;btrfs receive /home/backups2/&#39;=
</div><div><br></div><div>After send completes, on Device C</div><div>BTRFS=
 version: v4.7.3</div><div><span style=3D"font-size:small;background-color:=
rgb(255,255,255);text-decoration-style:initial;text-decoration-color:initia=
l;float:none;display:inline">btrfs su show /home/backups2/snapshot1</span><=
br></div><div><span style=3D"background-color:rgb(255,255,255);text-decorat=
ion-style:initial;text-decoration-color:initial;float:none;display:inline">=
<div><span style=3D"white-space:pre">	</span>Name: <span style=3D"white-spa=
ce:pre">			</span>snapshot1</div><div><span style=3D"white-space:pre">	</sp=
an>UUID: <span style=3D"white-space:pre">			</span>8a13aab5-8e44-2541-9082-=
bc583933b964</div><div><span style=3D"white-space:pre">	</span>Parent UUID:=
 <span style=3D"white-space:pre">		</span>54e9b4ff-46dc-534e-b70f-69eb7bb21=
028</div><div><span style=3D"white-space:pre">	</span>Received UUID: <span =
style=3D"white-space:pre">	</span>7c13d189-7fee-584e-ac90-e68cb0012f5c</div=
><div><span style=3D"white-space:pre">	</span>Creation time: <span style=3D=
"white-space:pre">		</span>2018-07-30 18:58:32 -0700</div><div><span style=
=3D"white-space:pre">	</span>Flags: <span style=3D"white-space:pre">			</sp=
an>readonly</div></span></div><div><br></div><div>1. I have gone through so=
me of the archived emails and have noticed people mentioning that</div><div=
>if received UUID is set, btrfs send propogates this &#39;received UUID&#39=
;. But in above case,=C2=A0</div><div>it&#39;s different for the same snaps=
hot on all three devices. Is this the expected behavior ?</div><div><br></d=
iv><div>2. We want to be able to start backing up from Device A to C, in ca=
se B goes down or needs=C2=A0</div><div>to be replaced. If received UUID is=
 expected to differ for the snapshot on device B and C, incremental</div><d=
iv>backups will not work from A to C without setting received UUID. I have =
seen python-btrfs</div><div>mentioned in a couple of emails; but have anyon=
e of you used it in a production environment ?</div><div><br></div><div>Thi=
s is my first post to this email. Please let me know if I am missing any de=
tails.</div><div><br></div><div>Thanks,</div><div>Gaurav</div><div><br></di=
v></div>

--0000000000007671f105724f1b1d--
