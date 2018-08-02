Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:40170 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387538AbeHBRte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 13:49:34 -0400
Received: by mail-ua0-f181.google.com with SMTP id m13-v6so1796533uaq.7
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 08:57:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBczyZBddarXcLKAjOZ=xQsFBSjbbJi-V20UB27Z5x+Y5g@mail.gmail.com>
References: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
 <CAJCQCtQWYM5Hb6-9QhRujcrP9Ou8u5N+RFLFzA=Za7Z1FeuakQ@mail.gmail.com> <CAN4oSBczyZBddarXcLKAjOZ=xQsFBSjbbJi-V20UB27Z5x+Y5g@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Thu, 2 Aug 2018 18:57:46 +0300
Message-ID: <CAN4oSBfGK_vTeSVi+47GoC9i155oyuvvczC5b0vVGEapHY+m4g@mail.gmail.com>
Subject: Re: Unmountable root partition
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000004ba624057275df59"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--0000000000004ba624057275df59
Content-Type: text/plain; charset="UTF-8"

FYI: According to ddrescue, there were read errors in +45% of the
partition. There were no chances to save anything from the disk.

2018-08-01 15:07 GMT+03:00 Cerem Cem ASLAN <ceremcem@ceremcem.net>:

> Yes, command output is as is, because I just copied and pasted into the
> mail. When I omit the `-t btrfs` part, result is the same.
>
> I'm now trying to rescue what I can, so getting a image dump with
> `ddrescue`. It's read about 25% without any errors but it will be expected
> to finish in 6 hours. Then I'll try btrfscue to see what happens.
>
> I know it's totally my fault because I must be ready for a total
> disk/pc/building burn out. Lessons learned.
>
> 2018-08-01 8:32 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>
>> On Tue, Jul 31, 2018 at 12:03 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net>
>> wrote:
>>
>> > 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo
>> > Gives the following error:
>> >
>> > mount: wrong fs type, bad option, bad superblock on ...
>> >
>> > 4. dmesg | tail
>> > Outputs the following:
>> >
>> >
>> > [17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:
>> > hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>> > [17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 02
>> 00 00
>> > 02 00
>> > [17755.840921] blk_update_request: I/O error, dev sda, sector 507906
>> > [17755.840941] EXT4-fs (dm-4): unable to read superblock
>>
>>
>> Are you sure this is the output for the command? Because you're
>> explicitly asking for type btrfs, which fails, and then the kernel
>> reports EXT4 superblock unreadable. What do you get if you omit -t
>> btrfs and just let it autodetect?
>>
>> But yeah, this is an IO error from the device and there's nothing
>> Btrfs can do about that unless there is DUP or raid1+ metadata
>> available.
>>
>> Is it possible this LV was accidentally reformatted ext4?
>>
>>
>> --
>> Chris Murphy
>>
>
>

--0000000000004ba624057275df59
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">FYI: According to ddrescue, there were read errors in +45%=
 of the partition. There were no chances to save anything from the disk.=C2=
=A0</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2018-08-=
01 15:07 GMT+03:00 Cerem Cem ASLAN <span dir=3D"ltr">&lt;<a href=3D"mailto:=
ceremcem@ceremcem.net" target=3D"_blank">ceremcem@ceremcem.net</a>&gt;</spa=
n>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Yes, command output =
is as is, because I just copied and pasted into the mail. When I omit the `=
-t btrfs` part, result is the same.=C2=A0<div><br></div><div>I&#39;m now tr=
ying to rescue what I can, so getting a image dump with `ddrescue`. It&#39;=
s read about 25% without any errors but it will be expected to finish in 6 =
hours. Then I&#39;ll try=C2=A0btrfscue to see what happens.=C2=A0</div><div=
><br></div><div>I know it&#39;s totally my fault because I must be ready fo=
r a total disk/pc/building burn out. Lessons learned.=C2=A0</div></div><div=
 class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">2018-08-01 8:32 GMT+03:00 Chris Murphy <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:lists@colorremedies.com" target=3D"_blank">lists@col=
orremedies.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span>On=
 Tue, Jul 31, 2018 at 12:03 PM, Cerem Cem ASLAN &lt;<a href=3D"mailto:cerem=
cem@ceremcem.net" target=3D"_blank">ceremcem@ceremcem.net</a>&gt; wrote:<br=
>
<br>
&gt; 3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo<br>
&gt; Gives the following error:<br>
&gt;<br>
&gt; mount: wrong fs type, bad option, bad superblock on ...<br>
&gt;<br>
&gt; 4. dmesg | tail<br>
&gt; Outputs the following:<br>
&gt;<br>
&gt;<br>
&gt; [17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:<br>
&gt; hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK<br>
&gt; [17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 02=
 00 00<br>
&gt; 02 00<br>
&gt; [17755.840921] blk_update_request: I/O error, dev sda, sector 507906<b=
r>
&gt; [17755.840941] EXT4-fs (dm-4): unable to read superblock<br>
<br>
<br>
</span>Are you sure this is the output for the command? Because you&#39;re<=
br>
explicitly asking for type btrfs, which fails, and then the kernel<br>
reports EXT4 superblock unreadable. What do you get if you omit -t<br>
btrfs and just let it autodetect?<br>
<br>
But yeah, this is an IO error from the device and there&#39;s nothing<br>
Btrfs can do about that unless there is DUP or raid1+ metadata<br>
available.<br>
<br>
Is it possible this LV was accidentally reformatted ext4?<br>
<span class=3D"m_2351317195924769091HOEnZb"><font color=3D"#888888"><br>
<br>
-- <br>
Chris Murphy<br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--0000000000004ba624057275df59--
