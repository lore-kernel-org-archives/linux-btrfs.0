Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8314 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753363AbbGXB5p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 21:57:45 -0400
Date: Thu, 23 Jul 2015 21:57:38 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
Message-ID: <20150724015738.GD28964@ret.masoncoding.com>
References: <559C9A75.60506@cn.fujitsu.com>
 <55AF6250.8070602@cn.fujitsu.com>
 <20150723202155.GC28964@ret.masoncoding.com>
 <55B186D1.30109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55B186D1.30109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 08:29:05AM +0800, Qu Wenruo wrote:

[ deadlock with the 070 patches ]

> Thanks Chris
> 
> We will investigate it with highest priority.
> 
> Thanks,
> Qu
> 

Thanks!  I'm doing a few more runs to make sure the lockup is new with
these patches.

-chris
