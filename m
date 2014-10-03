Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36902 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaJCNPR (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 3 Oct 2014 09:15:17 -0400
Message-ID: <542EA15F.9080703@suse.com>
Date: Fri, 03 Oct 2014 14:15:11 +0100
From: Filipe Manana <fdmanana@suse.com>
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>, dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: FIBMAP unsupported
References: <6602102.lhBckFYBLs@fb07-iapwap2> <20141002172549.GV11436@twin.jikos.cz> <2356843.HqzAreCEMf@ax5200p> <6603452.o3OqIjYaDr@ax5200p>
In-Reply-To: <6603452.o3OqIjYaDr@ax5200p>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/02/2014 11:11 PM, Marc Dietrich wrote:
> Am Donnerstag 02 Oktober 2014, 21:55:55 schrieb Marc Dietrich:
>> Will try to restore the file using btrfs restore....
> 
> ok, restore worked. I did some more tests. This is unrelated to CoW. It seems 
> that the "fallocate -n" in combination with "dd conv=notrunc" using large 
> files (>10G) triggers it. Maybe this rings some bells.

Just tried it and I confirm filefrag's call to ioctl FS_IOC_FIEMAP fails
with -EEXIST.

It's actually a known issue affecting any of the 3.17 RCs (except RC1).
The extent map manipulation/merging is broken for some cases. Try with
this 2 patches on top of 3.17-rcX:

https://patchwork.kernel.org/patch/4929981/
https://patchwork.kernel.org/patch/4945191/

Or, alternatively, reverting this patch:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=51f395ad4058883e4273b02fdebe98072dbdc0d2

Someone else reported on this list a write/pwrite/writev failure with
errno EEXIST too (and apparently caused by the same reason).

This broken extent map handling is serious IMHO, it can make fsync log
bogus extent items for example, amongst other possible bad and weird things.

> 
> Marc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
