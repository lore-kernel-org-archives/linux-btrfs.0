Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37475 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbcCYPM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 11:12:29 -0400
Date: Fri, 25 Mar 2016 11:12:11 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 25/27] btrfs: dedupe: Add support for compression and
 dedpue
Message-ID: <20160325151211.tfgux36zzpt6hthk@floor.thefacebook.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-26-git-send-email-quwenruo@cn.fujitsu.com>
 <20160324203504.m2b3lybguuf5r2hd@floor.thefacebook.com>
 <56F497FF.3010705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <56F497FF.3010705@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 09:44:31AM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2016/03/24 16:35 -0400:
> >On Tue, Mar 22, 2016 at 09:35:50AM +0800, Qu Wenruo wrote:
> >>From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> >>
> >>The basic idea is also calculate hash before compression, and add needed
> >>members for dedupe to record compressed file extent.
> >>
> >>Since dedupe support dedupe_bs larger than 128K, which is the up limit
> >>of compression file extent, in that case we will skip dedupe and prefer
> >>compression, as in that size dedupe rate is low and compression will be
> >>more obvious.
> >>
> >>Current implement is far from elegant. The most elegant one should split
> >>every data processing method into its own and independent function, and
> >>have a unified function to co-operate them.
> >
> >I'd leave this one out for now, it looks like we need to refine the
> >pipeline from dedup -> compression and this is just more to carry around
> >until the initial support is in.  Can you just decline to dedup
> >compressed extents for now?
> 
> Yes, completely no problem.
> Although this patch seems works well yet, but I also have planned to rework
> current run_delloc_range() to make it more flex and clear.
> 
> So the main object of the patch is more about raising attention for such
> further re-work.
> 
> And now it has achieved its goal.

Thanks, I do really like how you had compression in mind all along.

-chris

