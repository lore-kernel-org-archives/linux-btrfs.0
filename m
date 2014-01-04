Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39321 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754202AbaADTSX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 14:18:23 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49831 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzWjl-000Bwv-QU
	for linux-btrfs@vger.kernel.org; Sat, 04 Jan 2014 12:18:21 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C77903.9060408@jrs-s.net>
Date: Sat, 4 Jan 2014 12:18:22 -0700
Message-Id: <241D8699-CA7A-433E-B573-012F44026411@colorremedies.com>
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com> <52C74B00.7080906@jrs-s.net> <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com> <52C77903.9060408@jrs-s.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 7:59 PM, Jim Salter <jim@jrs-s.net> wrote:

> 
> On 01/03/2014 07:27 PM, Chris Murphy wrote:
>> This is the wrong way to solve this. /etc/grub.d/10_linux is subject to being replaced on updates. It is not recommended it be edited, same as for grub.cfg. The correct way is as I already stated, which is to edit the GRUB_CMDLINE_LINUX= line in /etc/default/grub. 
> Fair enough - though since I already have to monkey-patch 00_header, I kind of already have an eye on grub.d so it doesn't seem as onerous as it otherwise would. There is definitely a lot of work that needs to be done on the boot sequence for btrfs IMO.

Most of this work is done for a while in current versions of GRUB 2.00. There are a few fixes due in 2.02.  There are some logical challenges making snapshots bootable in a coherent way. But a major advantage of Btrfs is that functionality is contained in one place so once the kernel is booted things usually just work, so I'm not sure what else you're referring to? 


>> I think it's bad advice to recommend always persistently mounting a good volume with this option. There's a reason why degraded is not the default mount option, and why there isn't yet automatic degraded mount functionality. That fstab contains other errors.
> What other errors does it contain? Aside from adding the "degraded" option, that's a bone-stock fstab entry from an Ubuntu Server installation.

fs_passno is 1 which doesn't apply to Btrfs.


>> You're simply dissatisfied with the state of Btrfs development and are suggesting bad hacks as a work around. That's my argument. Again, if your use case requires automatic degraded mounts, use a technology that's mature and well tested for that use case. Don't expect a lot of sympathy if these bad hacks cause you problems later. 
> You're suggesting the wrong alternatives here (mdraid, LVM, etc) - they don't provide the features that I need or are accustomed to (true snapshots, copy on write, self-correcting redundant arrays, and on down the line).

Well actually LVM thinp does have fast snapshots without requiring preallocation, and uses COW. I'm not sure what you mean by self-correcting, but if the drive reports a read error md, lvm, and Btrfs raid1+ all will get missing data from mirror/parity reconstruction, and write corrected data back to the bad sector. All offer scrubbing (except Btrfs raid5/6). If you mean an independent means of verifying data via checksumming, true you're looking at Btrfs, ZFS, or PI.

> If you're going to shoo me off, the correct way to do it is to wave me in the direction of ZFS

There's no shooing, I'm just making observations.


Chris Murphy

