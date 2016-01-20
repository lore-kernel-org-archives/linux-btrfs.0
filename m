Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45170 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbcATRsf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 12:48:35 -0500
Date: Wed, 20 Jan 2016 12:48:23 -0500
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
Message-ID: <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com>
 <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 10:16:27AM -0500, Chris Mason wrote:
> On Tue, Jan 12, 2016 at 03:46:26PM +0800, Zhao Lei wrote:
> > reada create 2 works for each level of tree in recursion.
> > 
> > In case of a tree having many levels, the number of created works
> > is 2^level_of_tree.
> > Actually we don't need so many works in parallel, this patch limit
> > max works to BTRFS_MAX_MIRRORS * 2.
> 
> Hi,
> 
> I don't think you end up calling atomic_dec() for every time that
> reada_start_machine() is called.  Also, I'd rather not have a global
> static variable to limit the parallel workers, when we have more than
> one FS mounted it'll end up limiting things too much.
> 
> With this patch applied, I'm seeing deadlocks during btrfs/066.    You
> have to run the scrub tests as well, basically we're just getting
> fsstress run alongside scrub.
> 
> I'll run a few more times with it reverted to make sure, but I think
> it's the root cause.

I spoke too soon, it ended up deadlocking a few tests later.  Sorry for
now I'm pulling all the reada patches.  We'll sort out bug fixes vs
cleanups in later rcs.

With all of the reada patches removed, the deadlocks are gone.

-chris
