Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:57750 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3BNH7Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 02:59:25 -0500
Date: Thu, 14 Feb 2013 08:58:58 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Chris Murphy <lists@colorremedies.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com>
Message-ID: <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
 <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Feb 2013, Chris Murphy wrote:
>>> So the question is whether the cable problem has actually been fixed, and if you're still getting ICRC errors from the kernel.
>>
>> I'm not getting any block-layer errors from the kernel. The errors I posted originally are the only ones I'm getting.
>
> Previously you reported:
> Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
> Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }
>
> These are not block errors. You should not proceed until you're certain this isn't still intermittently occurring.

Sorry for being unclear. By "block-layer errors" I intended to mean 
hardware/driver errors, as those are, as opposed to filesystem errors, but 
I guess that's not the vernacular use of the term.

To try to be clearer, then:

I am not getting ICRC errors anymore, or any driver-related errors 
whatsoever. I was only getting them when sdd was originally lost, and have 
not been getting any of them since.

The errors I am currently getting, and the ones I was getting during the 
rebalance, are those I reported in the original mail; that is:

Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1
Feb 14 08:32:30 nerv kernel: [180511.764690] btrfs: bdev /dev/sdd1 errs: wr 288650, rd 26, flush 1, corrupt 0, gen 0

I am only getting those messages from the kernel, and nothing else. 
Currently, those two messages are the only ones I'm getting at all (except 
with slightly different numeric parameters, of course); while I was trying 
to rebalance, I also got messages looking like this:

Feb 12 22:57:16 nerv kernel: [59596.948464] btrfs: relocating block group 2879804932096 flags 17
Feb 12 22:57:45 nerv kernel: [59626.618280] btrfs_end_buffer_write_sync: 8 callbacks suppressed
Feb 12 22:57:45 nerv kernel: [59626.621893] btrfs_dev_stat_print_on_error: 8 callbacks suppressed
Feb 12 22:57:48 nerv kernel: [59629.569278] btrfs: found 46 extents

I hope that clears it up.

>>> Once that's solved, you should do a scrub, rather than a rebalance.
>>
>> Oh, will scrubbing actually rebalance the array? I was under the impression that it only checked for bad checksums.
>
> Scrubbing does not balance the volume. Based on the information you 
> supplied I don't really see the reason for a rebalance.

Maybe my terminology is wrong again, then, because I do see a reason to 
get the data properly replicated across the drives, which it doesn't seem 
to be now. That's what I meant by "rebalancing".

> What you do next depends on what your goal is for this data, on these 
> two disks, using btrfs. If the idea is to trust the data on the volume; 
> you still have the source data so I'd mkfs.btrfs on the disks and start 
> over. If the idea is to experiment and learn, you might want to do a 
> btrfsck, followed by a scrub.

I'm still keeping the original data just in case, of course. However, my 
primary goal right now is to learn how to manage redundancy reliably with 
btrfs. I mean, with md, I can easily handle a device failure and fix it up 
without having to remount or reboot; and I've assumed that I should be 
able to do that with btrfs as well (please correct me if that assumption 
is invalid, though).

> Btrfs is stable on stable hardware. Your hardware most definitely was 
> not stable during a series of writes. So I'd say all bets are off. That 
> doesn't mean it can't be fixed, but the very fact you're still getting 
> errors indicates something is still wrong.

Isn't btrfs' RAID1 supposed to be stable as long as only one disk fails, 
though?

> This:
> Feb 12 22:57:45 nerv kernel: [59626.644110] lost page write due to I/O error on /dev/sdd1
> Are not btrfs errors.

I see. I thought that was a btrfs error, but I was wrong then. Since I'm 
not actually getting any driver errors, though, and it's referring to sdd, 
doesn't that just mean, as I suspect, that btrfs is still trying to use 
the old defunct sdd instead of sdi as the drive became named after it was 
redetected?

> This:
> Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
> Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }

Just to be overly redundant: I'm not getting those anymore, and I only 
ever got them before the drive was redetected as sdi.

--

Fredrik Tolf
