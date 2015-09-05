Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33148 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbIEKNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Sep 2015 06:13:51 -0400
Received: by igbkq10 with SMTP id kq10so32317931igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Sep 2015 03:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150904211738.GB23944@carfax.org.uk>
References: <loom.20150904T230705-944@post.gmane.org> <20150904211738.GB23944@carfax.org.uk>
From: Ivan Petrovic <ivan@ipplus.rs>
Date: Sat, 5 Sep 2015 12:13:30 +0200
Message-ID: <CAEyaVk+U5dFt79d_yd+LAujQLRsy8o7_VfPS+==uRPa_2f-oVg@mail.gmail.com>
Subject: Re: unable to mount multi disk volume with recovery mode
To: Hugo Mills <hugo@carfax.org.uk>, Ivan <ivan@ipplus.rs>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know... but after btrfs-zero-log now I can't:

ivan@ipplus-dev:~$ sudo btrfs filesystem df /dev/sdb
[sudo] password for ivan:
ERROR: couldn't get space info - Inappropriate ioctl for device
ERROR: get_df failed Inappropriate ioctl for device
ivan@ipplus-dev:~$

So you're saying that I can't make first and third partition to work
with it's data? Maybe I'll try with btrfs-restore, do you think it can
rescue this 2 drives?

Thanks

2015-09-04 23:17 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
> On Fri, Sep 04, 2015 at 09:07:34PM +0000, Ivan wrote:
>>
>> Just to add this:
>>
>> ivan@ipplus-dev:~$ sudo btrfs filesystem df /mnt/ambis/
>> Data, single: total=108.76GiB, used=107.11GiB
>> System, single: total=32.00MiB, used=20.00KiB
>> Metadata, single: total=3.00GiB, used=2.34GiB
>> ivan@ipplus-dev:~$
>
>    (If you can't mount the FS, how did you get this output? -- In what
> I say below, I'm asuming that this was the last output from btrfs fi
> df on the broken filesystem before it broke).
>
>    This is the problem: You're using single for everything. That means
> that with the loss of one device, approximately one part in three of
> your filesystem is missing, including the metadata. If the missing
> drive is truly broken, this filesystem is dead, without any good means
> of recovery. You'll need to use your backups.
>
>    You would have to have RAID-1 system and metadata for the FS to be
> even partly recoverable with a missing device. (Or RAID-10, -5 or -6).
>
>    Hugo.
>
> --
> Hugo Mills             | "There's more than one way to do it" is not a
> hugo@... carfax.org.uk | commandment. It is a dire warning.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Ivan Petrović

IP PLUS STUDIO
Vojvode Stepe 403v, 11221 Beograd, Srbija
T: +381 11 630 2853
F: +381 11 630 2853
www.ipplus.rs

-- 
IP PLUS STUDIO
Vojvode Stepe 403v, 11221 Beograd, Srbija
T: +381 11 630 2853
F: +381 11 630 2853
www.ipplus.rs
