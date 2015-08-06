Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53030 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbbHFOoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 10:44:20 -0400
Date: Thu, 6 Aug 2015 10:44:09 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: qgroup: Fix a regression in qgroup reserved space.
Message-ID: <20150806144409.GJ19756@ret.masoncoding.com>
References: <1438584269-32634-1-git-send-email-quwenruo@cn.fujitsu.com>
 <55C31E01.7010204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55C31E01.7010204@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2015 at 04:42:41PM +0800, Qu Wenruo wrote:
> Hi Chris,
> 
> Would you please consider including this patch into v4.2 if it is still
> possible?
> 
> Although the fix is still not perfect and just a hotfix, as qgroup reserve
> parts still have a lot of problems from design and a lot of operations can
> still cause reserve space leak.
> 
> But considering how easy it is to trigger, I still hope it to be merged asap
> before 4.2.

Thanks Qu, I'll get this in.

-chris
