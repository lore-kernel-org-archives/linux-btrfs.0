Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56117 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbcA1Nan (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 08:30:43 -0500
Date: Thu, 28 Jan 2016 08:30:32 -0500
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
Message-ID: <20160128133032.aesambv5jlnungje@floor.thefacebook.com>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com>
 <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com>
 <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
 <00a501d15433$61275d10$23761730$@cn.fujitsu.com>
 <20160121141444.gygz5lrkerq67lxz@floor.thefacebook.com>
 <00ce01d15510$0b35adc0$21a10940$@cn.fujitsu.com>
 <20160122141917.qs632ec3iwykdfdm@floor.thefacebook.com>
 <006601d159a0$7a6a47c0$6f3ed740$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <006601d159a0$7a6a47c0$6f3ed740$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 03:49:54PM +0800, Zhao Lei wrote:
> I rebased following branch:
> https://github.com/zhaoleidd/btrfs.git integration-4.5
> 
> With updated patch to fix btrfs/066 bug.
> Bug reason is descripted in changelog of:
> btrfs: reada: avoid undone reada extents in btrfs_reada_wait
> 
> Test:
> 1: In the node which can repgoduce btrfs/066 bug,
>   Confirmed HAVING_BUG before patch, and NO_BUG after patch.
> 2: Run xfstests's btrfs group, confirmed no regression.
> 
> Most patchs in this branch are for reada, except this one for NO_SPACE bug:
> btrfs: Continue write in case of can_not_nocow
> 
> Cound you consider merging it in suitable time?

Thanks for tracking all of this down, I'll take a look.

-chris
