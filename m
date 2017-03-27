Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from erza.pados.hu ([176.9.136.194]:50572 "EHLO erza.pados.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752917AbdC0Ogq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 10:36:46 -0400
Mime-Version: 1.0
Date: Mon, 27 Mar 2017 14:12:58 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <c2f848ab7e4294f35f1bca29db33e3de@webmail.pados.hu>
From: "Karoly Pados" <pados@pados.hu>
Subject: Re: Bug: btrfs dev del missing fails where it shouldn't
To: "Duncan" <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
In-Reply-To: <pan$6d207$1e762e21$4d82ed9e$78bb3ca@cox.net>
References: <pan$6d207$1e762e21$4d82ed9e$78bb3ca@cox.net>
 <63b13b68a616abf8f828d6725f792be4@webmail.pados.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

March 24, 2017 6:49 AM, "Duncan" <1i5t5.duncan@cox.net> wrote:

> Karoly Pados posted on Thu, 23 Mar 2017 14:07:31 +0000 as excerpted:
> 
> [ Kernel 4.9.13, progs 4.9.1:
> 
> 1) Mkfs.btrfs a two-device raid1 data/metadata btrfs and mount it.
> 
> Don't put any data on it.
> 
> 2) Remove a device physically or at the block level
> 
> 3) Remount degraded and balance-convert data to single, metadata to dup. ]
> 
>> 4) Obviously the array still has a missing device, check this:
>> 
>> btrfs fi show Label: none uuid: 55fa0da0-26b5-4a66-ba54-e9488e47cf6e
>> Total devices 2 FS bytes used 320.00KiB
>> devid 1 size 3.74GiB used 896.00MiB path /dev/sda
>> *** Some devices missing
>> 
>> 5) Try to remove missing device and see the error:
>> 
>> btrfs dev del missing /mnt/volatile
>> ERROR: error removing device 'missing':
>> no missing devices found to remove
>> 
>> Step 5) failed and can be replaced by:
>> 
>> btrfs dev del 2 /mnt/volatile/
>> [ 402.828294] BTRFS info (device sdb): device deleted: id 2
>> 
>> btrfs fi
>> show Label: none uuid: [...]
>> Total devices 1 FS bytes used 320.00KiB
>> devid 1 size 3.74GiB used 896.00MiB path /dev/sda
>> 
>> Still, 'missing' should be working, and having to use the devid is a
>> PITA for both humans and scripts (the reason why 'missing' was added in
>> the first place).
> 
> btrfs dev del missing has had a bit of a history and is I believe broken
> on newer kernels (tho I'm not entirely sure whether it's entirely broken,
> or whether it still works in some specific cases, see why it couldn't be
> expected to work in yours, below). Obviously it's at least partially
> broken on 4.9. If you trace the delete-by-devid patches, you'll see the
> history there and that they were actually introduced in part to work
> around the broken delete missing feature.

Followed your hint/advice below, and I can testify that at least for my use-case and on 4.9,
'missing' works. Thank you! But please read further :)

> FWIW, the btrfs-device manpage, as of the progs-4.9 I still have
> installed here, at least, doesn't even appear to list "missing" as an
> option any longer.
> 
> The wiki does still discuss using missing, at least on the multiple-
> devices page, which obviously hasn't been updated in that regard recently
> as it doesn't (on quick read at least) appear to mention using dev-id at
> all, and it still uses delete instead of the newer remove (see below),
> too.

Might be, and I must confess I haven't looked up the man-pages, but that is because there are
pretty specific and unanimous advice everywhere *to use* 'missing'. If someone googles for
instructions on how to handle a failed array in btrfs, all the top results either mention only
'missing', or they also mention removal by devid but note that using 'missing' is the recommended
approach. And the official wiki of btrfs is no exception. So if 'missing' is not encouraged anymore
or as you say is expected to be broken except in some select cases, I'd suggest updating the wiki.

> But, even there, a close read says missing tells btrfs to delete the
> first device described by the filesystem metadata that wasn't present
> when the filesystem was mounted. And since your case does a remount, not
> a full unmount and clean mount, that "missing" device was present when
> the filesystem was mounted, so attempting to delete missing /should/ be
> expected to fail.

I checked, and a full unmount+mount instead of a remount makes 'missing' work for me as expected.
Thank you once more. Here though I have a (IMHO important) feature suggestion: make 'missing'
behave the same after a remount as after a full-unmount-mount. And though I have no specific
example yet, possibly other features too aside from 'missing'. For a simple reason:

Even if you describe 'missing' as "delete the first device described by the filesystem metadata
that wasn't present when the filesystem was mounted", no normal admin or user is going to interpret
it that way. You are right the info is in there, and kernel or btrfs devs will take that sentence
apart like lawyers and interpret it very exactly. But I dare to say that most admins think of
remount as unmount-mount-on-steroids, basically as a possibly atomic unmount+mount that does not
break file descriptors. My point is, I argue that most people will expect 'missing' to work after a
remount even after reading its correct description above. So I would either explicitly spell out in
the docs that 'missing' will not work in that case, or better, 'fix' it to work even after a
remount.

Greetings,
Karoly
