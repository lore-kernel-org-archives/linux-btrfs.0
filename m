Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:63544 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3HLRlb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 13:41:31 -0400
Message-ID: <52091E71.10405@giantdisaster.de>
Date: Mon, 12 Aug 2013 19:42:09 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Todor Ivanov <t.i.ivanov@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS corruptions counter
References: <CAOv4OrWkKGL37r+gnMtB8KbQip61NjhPpX1YA-rLCZQu4vDzHA@mail.gmail.com>
In-Reply-To: <CAOv4OrWkKGL37r+gnMtB8KbQip61NjhPpX1YA-rLCZQu4vDzHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/2013 18:57, Todor Ivanov wrote:
> Hi,
>
> We decided to give BTRFS a try. We find it very flexible and generally
> fast. However last week we had a problem with a Marvell controller in
> AHCI and one BTRFS formatted hard drive. We isolated the problem by
> relocating the disk to an Intel contoller (SATA controller: Marvell
> Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller (rev 11) had a
> lot of problems and I managed to overcome them by passing
> libata.force=noncq for a couple of weeks, until it failed generally).
> Now that the disk is on the intel contoller it works fine and data is
> intact, but whenever I do mount or unmount I see:
>
> Aug 10 18:34:47 MyServerHere kernel: btrfs: bdev /dev/sde1 errs: wr 0,
> rd 0, flush 0, corrupt 166, gen 0
>
> The problem is "corrupt 166"
> Sofar I did:
>
> 1. btrfsck and it reported everything is OK
> 2. btrfs scrub start /dev/sde1 and it again reported all is OK
>
> Am I missing something in my filesystem checks or there is another way
> to zero the corrupt counter?

These counters are not reset automatically. To do this manually, run 
this command:

     btrfs device stats [-z] <path>|<device>
         Show current device IO stats. -z to reset stats afterwards.

If you don't have this command, you can find instructions how to compile 
updated btrgs-progs tools here:

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#btrfs-progs_git_repository

Additionally, read the section "build dependencies" which contains a 
list of packages that are required to build the tools.


