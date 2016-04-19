Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:58787 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbcDSKtr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 06:49:47 -0400
Subject: Re: RAID5 Unable to remove Failing HD
To: Anand Jain <anand.jain@oracle.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
 <56BAFC15.6080106@oracle.com> <5714A1F7.3050509@bouton.name>
 <pan$d96e4$2cb56bbb$1d5f6612$721cfc21@cox.net> <5715F6A0.7030707@oracle.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <57160D47.8030300@bouton.name>
Date: Tue, 19 Apr 2016 12:49:43 +0200
MIME-Version: 1.0
In-Reply-To: <5715F6A0.7030707@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 19/04/2016 11:13, Anand Jain a écrit :
>
>>> # btrfs device delete 3 /mnt/store/
>>> ERROR: device delete by id failed: Inappropriate ioctl for device
>>>
>>> Were the patch sets above for btrfs-progs or for the kernel ?
>> [...]
>
>  By the way, For Lionel issue, delete missing should work ?
>  which does not need any additional patch.

Delete missing works with 4.1.15 and btrfs-progs 4.5.1 (see later), but
the device can't be marked missing online so there's no way to maintain
redundancy without downtime. I was a little surprised: I half-expected
something like this because reading this list, RAID recovery seems to
still be a pain point but this isn't documented anywhere and after
looking around the relevant information seems to only be in this thread
(and many come from md and don't read this list, so won't expect this
behavior at all).
While I was waiting for directions the system crashed with a kernel
panic (clearly linked to IO errors according to the kernel panic but I
couldn't get all the stacktrace) and the system wasn't able to boot
properly (kernel panic shortly after the system mounted the filesystem
on each boot) until I removed the faulty drive (apparently it was
somehow readable enough to be recognized, but not enough to be usable).
After removing the faulty drive delete missing worked and a balance is
currently running (by the way it seems the drive bay was faulty: the
drive was not firmly fixed and it's cage could move a bit around in the
chassis and it was the only one, I didn't expect this and from
experience it's probably a factor in the hardware failure).

There may have been fixes since 4.1.15 to prevent the kernel panic
(there was only one device with IO errors, so ideally it shouldn't be
able to bring down the kernel) so it may not be worth further analysis.
That said I'll have 2 new drives next week (one replacement, one spare)
and I have a chassis lying around where I could try to replicate
failures with various kernels on a RAID1 filesystem built with a brand
new drive and the faulty drive (until the faulty drive completely dies
which they usually do in my experience) so if someone wants some tests
done with 4.6-rcX or even 4.6-rcX + patches I can spend some time on it
next week.

Lionel
