Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbbIBPCB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 11:02:01 -0400
Date: Wed, 2 Sep 2015 17:01:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] btrfs-progs: stat info for btrfs rescue
 chunk-recover
Message-ID: <20150902150119.GM11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 02, 2015 at 08:22:28PM +0800, Zhao Lei wrote:
> chunk-recover need to use many many time in scan_devices(),
> and no output in screen:
>  # btrfs rescue chunk-recover /dev/sda6
>  (no output here, but need long time)
> 
> To notice user that "the command is not hang", this patch add
> dynamic updated stat information in above period:
>  # btrfs rescue chunk-recover /dev/sda6
>  Scanning: DONE in dev[0], 19998441472 in dev[1], DONE in dev[2]
>  (until)
>  Scanning: DONE in dev0, DONE in dev1, DONE in dev2
>  Check chunks successfully with no orphans
>  Recover the chunk tree successfully.
> 
> 
> Changelog v2->v3:
>  Add [PATCH 2/4] to fix a potential invalid memory access of pthread.
> 
> Changelog v1->v2:
>  [PATCH 3/3] in v1 lost a little cleanup, added in v2.
> 
> Zhao Lei (4):
>   btrfs-progs: use for loop for scan_devices
>   btrfs-progs: Use long type to get thread's return value
>   btrfs-progs: stat info for btrfs rescue chunk-recover
>   btrfs-progs: Fix some spelling typo in chunk-recover.c

All applied, thanks. I've split patch 4 into two, typo fixes and unused
argument removal, please keep such changes separate.
