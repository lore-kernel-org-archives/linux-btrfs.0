Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:53624 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbcGQVor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 17:44:47 -0400
Subject: Re: Status of SMR with BTRFS
To: Henk Slager <eye1tm@gmail.com>
References: <91da7783-ffa1-7d35-a364-344c61e7ddbe@matthiasprager.de>
 <CAPmG0jb+FMOMNWhsOhE1gzsry_x862pjSO_wV8_PFbyaBoEmUg@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Matthias Prager <linux@matthiasprager.de>
From: Matthias Prager <linux@matthiasprager.de>
Message-ID: <5c31c6fd-5f4a-0fb6-07c9-a56964f30262@matthiasprager.de>
Date: Sun, 17 Jul 2016 23:44:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jb+FMOMNWhsOhE1gzsry_x862pjSO_wV8_PFbyaBoEmUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 17.07.2016 um 22:10 schrieb Henk Slager:
> What kernel (version) did you use ?
> I hope it included:
> http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=bugzilla-93581&id=7c4fbd50bfece00abf529bc96ac989dd2bb83ca4
> 
> so >= 4.4, as without this patch, it is quite problematic, if not
> impossible, to use this 8TB Seagate SMR drive with linux without doing
> other patches or setting/module changes.
Thanks for that pointer, I tested kernels 3.18.28, 4.1.[17+19] and 4.5.0
. I had seen task aborts on the drive when io-stressing it with kernels
3.18 and 4.1 (and ext4), but I never figured out the exact reason. Since
I'm currently stuck at kernel 4.1.x, I did not research this any further
(kernels >=4.2 aren't usable in esxi-guests when using pass-through
devices due to irq handling issues which lead to driver inits failing -
I'm told vmware is still sitting on a fix).


> Since this patch, I have been using the drive for cold storage
> archiving, connected to a Baytrail SoC SATA port. I use bcache
> (writethrough or writearound) on an 8TB GPT partition that has a LUKS
> container that is Btrfs m-dup, d-single formatted and mounted
> compress=lzo,noatine,nossd. It is only powered on once a month for a
> day or so and then it receives incremental snapshots mostly or some
> SSD or flash images of 10-50G.
> I have more or less kept all the snapshots sofar, so chunks keep being
> added to previously unwritten space, so as sequential as possible.
Mhh, see that would be one too many layers of complexity for my taste in
such a setup - the Seagate SMR drives are fast enough to handle Gbit-LAN
speeds if they are served mostly large sequential chunks by the file
system, which f2fs actually manages to do (cold storage in my scenario
too). Btrfs does too many scattered writes for this to work without
bandages (i.e. caching or snapshotting) (although I do see the advantage
in having checksums for data which you write once and then read like
once every year).


> If free space would be heavily fragmented and also files would be
> heavily fragmented and the disk would be very full, adding new files
> or modifying would be very slow. You see than many seconds that the
> drive is active but no traffic on the SATA link. Also then there is
> the risk that the default '/sys/block/$(kerneldevname)/device/timeout'
> of 30 secs is too low, and that the kernel might reset the SATA link.
> A SATA link still happened 2x the last 1/2 year, I haven't really
> looked at the details sofar, just rebooted at some point in time
> later, but I will set the timeout at least higher, e.g. 180, and then
> see if ata errors/resets still occur. It might be FW crashes as well.
As far as I've tested f2fs never backed the SMR drive into a corner,
which is probably due to it's sequential write pattern as a
log-structured file system and it's background garbage collection (i.e.
defragmentation) - even in a full state. I imagine this will probably
not work out for hot data though.


> 
> At least this SMR drive is not advised to use in raid setups. As
> not-so-active array it might work if you use the right timeouts and
> scterc etc, but if have seen how long the wait on the SATA link can be
> and that makes me realize that the stamp 'Archive Drive' done by
> Seagate has a clear reason.
Agreed these drives do need special handling. For archival workloads
with cold data they can be used if the file system is kind enough. I
wouldn't be comfortable using these drives in any scenario where they
might be backed into a corner in which case the wait times are far to
uncalculable for my taste.


---
Matthias
