Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LSCEr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 21:04:47 -0500
Date: Wed, 19 Dec 2012 10:02:43 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wade Cline <clinew@linux.vnet.ibm.com>
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [PATCH] [RFC v2] Btrfs: Subpagesize blocksize (WIP).
Message-ID: <20121219020242.GB14426@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com>
 <20121218073050.GA19332@liubo.cn.oracle.com>
 <50D02E0A.8080505@cn.fujitsu.com>
 <50D0EDAA.3090202@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50D0EDAA.3090202@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 02:26:50PM -0800, Wade Cline wrote:
> On 12/18/2012 12:49 AM, Miao Xie wrote:
> 
> >On tue, 18 Dec 2012 15:30:51 +0800, Liu Bo wrote:
> >>On Mon, Dec 17, 2012 at 11:13:25PM -0800, clinew@linux.vnet.ibm.com wrote:
> >>>From: Wade Cline<clinew@linux.vnet.ibm.com>
> >>>
> >>>v1 ->  v2:
> >>>- Added Signed-off-by tag (it's kind of important).
> >>>
> >>>This patch is only an RFC. My internship is ending and I was hoping
> >>>to get some feedback and incorporate any suggestions people may
> >>>have before my internship ends along with life as we know it (this
> >>>Friday).
> >>>
> >>>The filesystem should mount/umount properly but tends towards the
> >>>explosive side when writes start happening. My current focus is on
> >>>checksumming issues and also an error when releasing extent buffers
> >>>when creating a large file with 'dd'... and probably any other
> >>>method. There's still a significant amount of work that needs to be
> >>>done before this should be incorporated into mainline.
> >>>
> >>>A couple of notes:
> >>>     - Based off of Josef's btrfs-next branch, commit
> >>>       8d089a86e45b34d7bc534d955e9d8543609f7e42
> >>>     - C99-style comments are "meta-comments" where I'd like more
> >>>       feedback; they aren't permanent but make 'checkpatch' moan.
> >>>     - extent_buffer allocation and freeing need their code paths
> >>>       merged; they're currently in separate functions and are both
> >>>       very ugly.
> >>>     - The patch itself will eventually need to be broken down
> >>>       into smaller pieces if at all possible...
> >>
> >>Could you please first elaborate why we need this subpagesize stuff and
> >>any user case in this patch's commit log?
> >>Or Am I missing something?
> >
> >It is used on the machines on which the page size is larger than 4KB (Such as powerpc)
> >
> >Thanks
> >Miao
> 
> Yeah. Basically, if we create a btrfs filesystem with a 4k blocksize
> then that filesystem is incompatible with architectures such as PowerPC
> and MIPS which have a page size larger than 4k.
> 
> -Wade
> 

I'm just saying there _should_ be some kind of such description about
the patch in your commit log...

That's for those who don't ever know the background of the idea.

thanks,
liubo
