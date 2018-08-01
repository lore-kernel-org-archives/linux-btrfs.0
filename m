Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42133 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732367AbeHAT7v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 15:59:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id u202-v6so13963026lff.9
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2018 11:12:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdc26113-5a70-0802-7f12-1a43f7a92aee@mendix.com>
References: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
 <bdc26113-5a70-0802-7f12-1a43f7a92aee@mendix.com>
From: Gaurav Sanghavi <gaurav.ms5@gmail.com>
Date: Wed, 1 Aug 2018 11:12:31 -0700
Message-ID: <CANfewpHTXQmcHpOFqOJ0Uuqnn+_DCqt3uQutov_QQM3TRzQomA@mail.gmail.com>
Subject: Re: Expected Received UUID
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000008c74fe057263a431"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--0000000000008c74fe057263a431
Content-Type: text/plain; charset="UTF-8"

Hi,

Here are the kernel details (uname -a):

Device A (Debian 8.10):
Linux DeviceA 3.16.0-4-amd64 #1 SMP Debian 3.16.51-3 (2017-12-13) x86_64
GNU/Linux

Device B (Debian 8.11):
Linux DeviceB 3.16.0-4-amd64 #1 SMP Debian 3.16.51-3 (2017-12-13) x86_64
GNU/Linux

Device C (Debian 8.9):
Linux DeviceC 3.16.0-4-amd64 #1 SMP Debian 3.16.43-2+deb8u3 (2017-08-15)
x86_64 GNU/Linux

All devices run Debian Jessie but I updated btrfs-tools and btrfs-progs on
devices B and C using the
stretch repository to see the Received UUID details ( I had not come across
python-btrfs earlier )

On Tue, Jul 31, 2018 at 4:37 PM, Hans van Kranenburg <
hans.van.kranenburg@mendix.com> wrote:

> Hi,
>
> Can you please report the kernel versions you are using on every system
> (uname -a)?
>
> I would indeed expect the Received UUID value for C to have the same
> uuid as the original UUID of A, so the b00e8ba1 one.
>
> The send part, generating the send stream is done by the running kernel.
> The receive part is done by the userspace btrfs progs. The btrfs progs
> receive code just sets the Received UUID to whatever it reads from the
> send stream information.
>
> So, your sending kernel version is important here.
>
> When looking up the lines that send the UUID, in fs/btrfs/send.c, I can
> see there was a problem like this in the past:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/lin
> ux.git/commit/?id=b96b1db039ebc584d03a9933b279e0d3e704c528
>
> I was introduced between linux 4.1 and 4.2 and solved in 2015 with that
> commit, which ended up somewhere in 4.3 I think.
>
> From the btrfs-progs versions you list, I suspect this is a Debian
> Jessie and 2x Debian Stretch, but the Debian 3.16 and 4.9 kernels would
> not should not have this issue.
>
> On 07/31/2018 07:42 PM, Gaurav Sanghavi wrote:
> > Hello everyone,
> >
> > While researching BTRFS for a project that involves backing up snapshots
> > from device A to device B
> > before consolidating backups from device B to device C, I noticed that
> > received UUID on snapshot on
> > device C is not the same as received UUID for the same snapshot on
> > device B. Here are my steps:
> >
> > 1. Device A
> > BTRFS version: v3.17
> >
> > btrfs su sn -r /home/test/snapshot1 /home/test/snaps/snapshot1
> > btrfs su show /home/test/snaps/snapshot1
> > Name: snapshot1
> > uuid: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> > Parent uuid: cb570dec-e9fd-1f40-99d2-2070c8ee2466
> >         Received UUID:      ---
> > Creation time: 2018-07-30 18:32:37
> > Flags: readonly
> >
> > 2. Send to Device B
> > btrfs send /home/test/snaps/snapshot1 | ssh <device b> 'btrfs receive
> > /home/backups/'
> >
> > After send completes, on Device B
> > BTRFS version: v4.7.3
> > btrfs su show /home/backups/snapshot1
> > Name: snapshot1
> > UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> > Parent UUID: a2314f7c-4b11-ed40-901f-f1acb5ebf802
> > Received UUID: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> > Creation time: 2018-07-30 18:42:37 -0700
> > Flags: readonly
> >
> >
> > 3. Send to Device C
> > btrfs send /home/backups/snapshot1 | ssh <device c> 'btrfs receive
> > /home/backups2/'
> >
> > After send completes, on Device C
> > BTRFS version: v4.7.3
> > btrfs su show /home/backups2/snapshot1
> > Name: snapshot1
> > UUID: 8a13aab5-8e44-2541-9082-bc583933b964
> > Parent UUID: 54e9b4ff-46dc-534e-b70f-69eb7bb21028
> > Received UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> > Creation time: 2018-07-30 18:58:32 -0700
> > Flags: readonly
> >
> > 1. I have gone through some of the archived emails and have noticed
> > people mentioning that
> > if received UUID is set, btrfs send propogates this 'received UUID'. But
> > in above case,
> > it's different for the same snapshot on all three devices. Is this the
> > expected behavior ?
> >
> > 2. We want to be able to start backing up from Device A to C, in case B
> > goes down or needs
> > to be replaced. If received UUID is expected to differ for the snapshot
> > on device B and C, incremental
> > backups will not work from A to C without setting received UUID. I have
> > seen python-btrfs
> > mentioned in a couple of emails; but have anyone of you used it in a
> > production environment ?
> >
> > This is my first post to this email. Please let me know if I am missing
> > any details.
> >
> > Thanks,
> > Gaurav
> >
>
> --
> Hans van Kranenburg
>

--0000000000008c74fe057263a431
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>Here are the kernel details (uname =
-a):<br></div><div><br></div><div>Device A (Debian 8.10):=C2=A0</div><div>L=
inux DeviceA 3.16.0-4-amd64 #1 SMP Debian 3.16.51-3 (2017-12-13) x86_64 GNU=
/Linux<br></div><div><br></div><div>Device B (Debian 8.11):</div><div>Linux=
 DeviceB 3.16.0-4-amd64 #1 SMP Debian 3.16.51-3 (2017-12-13) x86_64 GNU/Lin=
ux<br></div><div><br></div><div>Device C (Debian 8.9):</div><div>Linux Devi=
ceC 3.16.0-4-amd64 #1 SMP Debian 3.16.43-2+deb8u3 (2017-08-15) x86_64 GNU/L=
inux<br></div><div><br></div><div>All devices run Debian Jessie but I updat=
ed btrfs-tools and btrfs-progs on devices B and C using the</div><div>stret=
ch repository to see the Received UUID details ( I had not come across pyth=
on-btrfs earlier )</div><div><br></div><div>On Tue, Jul 31, 2018 at 4:37 PM=
, Hans van Kranenburg <span dir=3D"ltr">&lt;<a href=3D"mailto:hans.van.kran=
enburg@mendix.com" target=3D"_blank">hans.van.kranenburg@mendix.co<wbr>m</a=
>&gt;</span> wrote:<br></div><div class=3D"gmail_extra"><div class=3D"gmail=
_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex">Hi,<br>
<br>
Can you please report the kernel versions you are using on every system<br>
(uname -a)?<br>
<br>
I would indeed expect the Received UUID value for C to have the same<br>
uuid as the original UUID of A, so the b00e8ba1 one.<br>
<br>
The send part, generating the send stream is done by the running kernel.<br=
>
The receive part is done by the userspace btrfs progs. The btrfs progs<br>
receive code just sets the Received UUID to whatever it reads from the<br>
send stream information.<br>
<br>
So, your sending kernel version is important here.<br>
<br>
When looking up the lines that send the UUID, in fs/btrfs/send.c, I can<br>
see there was a problem like this in the past:<br>
<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it/commit/?id=3Db96b1db039ebc584d03a9933b279e0d3e704c528" rel=3D"noreferrer=
" target=3D"_blank">https://git.kernel.org/pub/scm<wbr>/linux/kernel/git/to=
rvalds/lin<wbr>ux.git/commit/?id=3Db96b1db039eb<wbr>c584d03a9933b279e0d3e70=
4c528</a><br>
<br>
I was introduced between linux 4.1 and 4.2 and solved in 2015 with that<br>
commit, which ended up somewhere in 4.3 I think.<br>
<br>
>From the btrfs-progs versions you list, I suspect this is a Debian<br>
Jessie and 2x Debian Stretch, but the Debian 3.16 and 4.9 kernels would<br>
not should not have this issue.<br>
<div class=3D"m_-4478840934702430419m_-652798433908407617HOEnZb"><div class=
=3D"m_-4478840934702430419m_-652798433908407617h5"><br>
On 07/31/2018 07:42 PM, Gaurav Sanghavi wrote:<br>
&gt; Hello everyone,=C2=A0<br>
&gt; <br>
&gt; While researching BTRFS for a project that involves backing up snapsho=
ts<br>
&gt; from device A to device B=C2=A0<br>
&gt; before consolidating backups from device B to device C, I noticed that=
<br>
&gt; received UUID on snapshot on=C2=A0<br>
&gt; device C is not the same as received UUID for the same snapshot on<br>
&gt; device B. Here are my steps:<br>
&gt; <br>
&gt; 1. Device A<br>
&gt; BTRFS version: v3.17<br>
&gt; <br>
&gt; btrfs su sn -r /home/test/snapshot1 /home/test/snaps/snapshot1<br>
&gt; btrfs su show /home/test/snaps/snapshot1<br>
&gt; Name: snapshot1<br>
&gt; uuid: b00e8ba1-5aaa-3641-9c4c-e168ee<wbr>e5c296<br>
&gt; Parent uuid: cb570dec-e9fd-1f40-99d2-2070c8<wbr>ee2466<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 Received UUID:=C2=A0 =C2=A0 =C2=A0 ---<br>
&gt; Creation time: 2018-07-30 18:32:37<br>
&gt; Flags: readonly<br>
&gt; <br>
&gt; 2. Send to Device B<br>
&gt; btrfs send /home/test/snaps/snapshot1 | ssh &lt;device b&gt; &#39;btrf=
s receive<br>
&gt; /home/backups/&#39;<br>
&gt; <br>
&gt; After send completes, on Device B<br>
&gt; BTRFS version: v4.7.3<br>
&gt; btrfs su show /home/backups/snapshot1<br>
&gt; Name: snapshot1<br>
&gt; UUID: 7c13d189-7fee-584e-ac90-e68cb0<wbr>012f5c<br>
&gt; Parent UUID: a2314f7c-4b11-ed40-901f-f1acb5<wbr>ebf802<br>
&gt; Received UUID: b00e8ba1-5aaa-3641-9c4c-e168ee<wbr>e5c296<br>
&gt; Creation time: 2018-07-30 18:42:37 -0700<br>
&gt; Flags: readonly<br>
&gt; <br>
&gt; <br>
&gt; 3. Send to Device C<br>
&gt; btrfs send /home/backups/snapshot1 | ssh &lt;device c&gt; &#39;btrfs r=
eceive<br>
&gt; /home/backups2/&#39;<br>
&gt; <br>
&gt; After send completes, on Device C<br>
&gt; BTRFS version: v4.7.3<br>
&gt; btrfs su show /home/backups2/snapshot1<br>
&gt; Name: snapshot1<br>
&gt; UUID: 8a13aab5-8e44-2541-9082-bc5839<wbr>33b964<br>
&gt; Parent UUID: 54e9b4ff-46dc-534e-b70f-69eb7b<wbr>b21028<br>
&gt; Received UUID: 7c13d189-7fee-584e-ac90-e68cb0<wbr>012f5c<br>
&gt; Creation time: 2018-07-30 18:58:32 -0700<br>
&gt; Flags: readonly<br>
&gt; <br>
&gt; 1. I have gone through some of the archived emails and have noticed<br=
>
&gt; people mentioning that<br>
&gt; if received UUID is set, btrfs send propogates this &#39;received UUID=
&#39;. But<br>
&gt; in above case,=C2=A0<br>
&gt; it&#39;s different for the same snapshot on all three devices. Is this=
 the<br>
&gt; expected behavior ?<br>
&gt; <br>
&gt; 2. We want to be able to start backing up from Device A to C, in case =
B<br>
&gt; goes down or needs=C2=A0<br>
&gt; to be replaced. If received UUID is expected to differ for the snapsho=
t<br>
&gt; on device B and C, incremental<br>
&gt; backups will not work from A to C without setting received UUID. I hav=
e<br>
&gt; seen python-btrfs<br>
&gt; mentioned in a couple of emails; but have anyone of you used it in a<b=
r>
&gt; production environment ?<br>
&gt; <br>
&gt; This is my first post to this email. Please let me know if I am missin=
g<br>
&gt; any details.<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Gaurav<br>
&gt; <br>
<br>
</div></div><span class=3D"m_-4478840934702430419m_-652798433908407617HOEnZ=
b"><font color=3D"#888888">-- <br>
Hans van Kranenburg<br>
</font></span></blockquote></div><br></div></div>

--0000000000008c74fe057263a431--
