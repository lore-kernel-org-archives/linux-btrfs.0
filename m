Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56231 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbaGCOA5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 10:00:57 -0400
Message-ID: <53B56211.4060403@fb.com>
Date: Thu, 3 Jul 2014 10:00:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
References: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com> <53B539CE.7070201@cn.fujitsu.com>
In-Reply-To: <53B539CE.7070201@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2014 07:09 AM, Miao Xie wrote:
> CC Anand Jain
> 
> Sorry, please ignore this patch.
> Anand wrote the same patch several days ago, so this bug fix belongs to Anand
> though he NACKed his patch at that time.

It certainly looks right, but Anand had mentioned that he had a few
questions on testing.  I've pulled it out for now, but I'll take Anand's
version when you're both happy.

-chris
