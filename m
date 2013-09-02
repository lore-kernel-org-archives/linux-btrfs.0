Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:58817 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039Ab3IBW2b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 18:28:31 -0400
Received: by mail-qa0-f44.google.com with SMTP id w8so968331qac.17
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Sep 2013 15:28:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130902220006.GA6389@carfax.org.uk>
References: <CAD+_0YrG2ju47suCSRKta+bONwUPcjTpv1y=11rkVNqVtHHwiQ@mail.gmail.com>
	<20130902220006.GA6389@carfax.org.uk>
Date: Tue, 3 Sep 2013 00:28:30 +0200
Message-ID: <CAD+_0YqsQRO90Lx1R64h8EE-L=4zrE6CEQGDKy-h=92hLLptWw@mail.gmail.com>
Subject: Re: Recovering from csum errors
From: Rain Maker <rainmaker52@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Rain Maker <rainmaker52@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First of all, thanks for the quick response. Reply inline.

2013/9/3 Hugo Mills <hugo@carfax.org.uk>:
> On Mon, Sep 02, 2013 at 11:41:12PM +0200, Rain Maker wrote:
>> Now, I removed the offending file. But is there something else I
>> should have done to recover the data in this file? Can it be
>> recovered?
>
>    No, and no. The data's failing a checksum, so it's basically
> broken. If you had a btrfs RAID-1 configuration, the FS would be able
> to recover from one broken copy using the other (good) copy.
>
Ofcourse, this makes sense.

I know filesystem recovery in BTRFS is incomplete. I'm opting for a
override for these usecases. I mean; the filesystem still knows the
checksum. There are 2 possibilities:
- The checksum is wrong
- The data is wrong

In case the checksum is wrong, why is there no possibility to
recalculate the checksum and continue with the file (taking small
corruptions for granted)? In this case (and, I believe, in more
cases), it's a VM. I could have run Windows chkdsk from the VM to see
what I could have salvaged.
In case the data is wrong, there may be a reverse CRC32 algorithm
implemented. Most likely it's only several bytes which got "flipped".
On modern hardware, it shouldn't take that much time to brute-force
the checksum, especially considering we have a good guess (the raw,
corrupted data).

Now, the VM I removed did not have any special data in it (+ I make
backups), but it could've been much worse.

>> I'm running 3.11-rc7. It is a single disk btrfs filesystem. I have
>> several subvolumes defined, one of which for VMWare Workstation (on
>> which the corruption took place).
>
>    Aaah, the VM workload could explain this. There's some (known,
> won't-fix) issues with (I think) direct-IO in VM guests that can cause
> bad checksums to be written under some circumstances.
>
>    I'm not 100% certain, but I _think_ that making your VM images
> nocow (create an empty file with touch; use chattr +C; extend the file
> to the right size) may help prevent these problems.
>
Hmm, could try that. Thanks for the tip.

I could also disable writeback cache on the VM. But, VMWare uses it's
own "vmblock" kernel module for I/O, so I'm not sure if this would do
any good. Then ofcourse, there's the performance hit.

>> Is the only logical explanation for this some kind of hardware failure
>> (SATA controller, power supply...), or could there be something more
>> to this?
>
>    As above, there's some direct-IO problems with data changing
> in-flight that can lead to bad checksums. Fixing the issue would cause
> some fairly serious slow-downs in performance for that case, which is
> rather against what direct-IO is trying to do, so I think it's
> unlikely the behaviour will be changed.
>
>    Of course, I could be completely wrong about all this, and you've
> got bad RAM or PSU something...
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>     --- "What are we going to do tonight?" "The same thing we do ---
>             every night, Pinky.  Try to take over the world!"
