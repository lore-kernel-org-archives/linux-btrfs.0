Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34503 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbdBHUb1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 15:31:27 -0500
Received: by mail-io0-f177.google.com with SMTP id l66so17789ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 12:31:26 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c124sm11647735ioc.39.2017.02.08.09.51.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Feb 2017 09:51:02 -0800 (PST)
Subject: Re: understanding disk space usage
To: linux-btrfs@vger.kernel.org
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
 <22683.12104.679173.639568@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <171155ef-93c2-f438-3bbd-ca550381c80d@gmail.com>
Date: Wed, 8 Feb 2017 12:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <22683.12104.679173.639568@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-08 09:46, Peter Grandi wrote:
>>> My system is or seems to be running out of disk space but I
>>> can't find out how or why. [ ... ]
>>> Filesystem            Size  Used Avail Use% Mounted on
>>> /dev/sda3              28G   26G  2.1G  93% /
> [ ... ]
>> So from chunk level, your fs is already full.  And balance
>> won't success since there is no unallocated space at all.
>
> To add to this, 28GiB is a bit too small for Btrfs, because at
> that point chunk size is 1GiB. I have the habit of sizing
> partitions to an exact number of GiB, and that means that most
> of 1GiB will never be used by Btrfs because there is a small
> amount of space allocated that is smaller than 1GiB and thus
> there will be eventually just less than 1GiB unallocated.
> Unfortunately the chunk size is not manually settable.
28GB is a perfectly reasonable (if a bit odd) size for a non-mixed-mode 
volume.  The issue isn't total size, it's the difference between total 
size and the amount of data you want to store on it. and how well you 
manage chunk usage.  If you're balancing regularly to compact chunks 
that are less than 50% full, you can get away with as little as 4GB of 
extra space beyond your regular data-set with absolutely zero issues. 
I've run full Linux installations in VM's with BTRFS on 16GB disk images 
before with absolutely zero issues, and have a handful of fairly active 
8GB BTRFS volumes on both of my primary systems that never have any 
issues with free space despite averaging 5GB of space usage.
>
> Example here from 'btrfs fi usage':
>
> Overall:
>     Device size:                  88.00GiB
>     Device allocated:             86.06GiB
>     Device unallocated:            1.94GiB
>     Device missing:                  0.00B
>     Used:                         80.11GiB
>     Free (estimated):              6.26GiB      (min: 5.30GiB)
>
> That means that I should 'btrfs balance' now, because of the
> 1.94GiB "unallocated", 0.94GiB will never be allocated, and that
> leaves just 1GiB "unallocated" which is the minimum for running
> 'btrfs balance'. I have just done so and this is the result:
Actually, that 0.94GB would be used.  BTRFS will create smaller chunks 
if it has to, so if you allocated two data chunks with that 1.94GB of 
space, you would get one 1GB chunk and one 0.94GB chunk.
>
> Overall:
>     Device size:                  88.00GiB
>     Device allocated:             82.03GiB
>     Device unallocated:            5.97GiB
>     Device missing:                  0.00B
>     Used:                         80.11GiB
>     Free (estimated):              6.26GiB      (min: 3.28GiB)
>
> At some point I had decided to use 'mixedbg' allocation to
> reduce this problem and hopefully improve locality, but that
> means that metadata and data need to have the same profile, and
> I really want metadata to be 'dup' because of checksumming,
> and I don't want data to be 'dup' too.
You could also use larger partitions and keep a better handle on free space.
>
>> [ ... ] To proceed, add a larger device to current fs, and do
>> a balance or just delete the 28G partition then btrfs will
>> handle the rest well.
>
> Usually for this I use a USB stick, with a 1-3GiB partition plus
> a bit extra because of that extra bit of space.
If you have a lot of RAM and can guarantee that things won't crash (or 
don't care about the filesystem too much and are just trying to avoid 
having to restore a backup), a ramdisk works well for this too.
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_free_space_do_I_have.3F
> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
> marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>
> Unfortunately if it is a single device volume and metadata is
> 'dup' to remove the extra temporary device one has first to
> convert the metadata to 'single' and then back to 'dup' after
> removal.
This shouldn't be needed, if it is then it's a bug that should be 
reported and ideally fixed (there was such a bug when converting from 
multi-device raid profiles to single device, but that got fixed quite a 
few kernel versions ago (I distinctly remember because I wrote the fix)).
>
> There are also some additional reasons why space used (rather
> than allocated) may be larger than expected, in special but not
> wholly infrequent cases. My impression is that the Btrfs design
> trades space for performance and reliability.
In general, yes, but a more accurate statement would be that it offers a 
trade-off between space and convenience.  If you're not going to take 
the time to maintain the filesystem properly, then you will need more 
excess space for it.
