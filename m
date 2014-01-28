Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47443 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbaA1O4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 09:56:07 -0500
Message-ID: <52E7C4FE.80104@fb.com>
Date: Tue, 28 Jan 2014 09:55:58 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] Btrfs: don't mix the ordered extents of all files
 together during logging the inodes
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com> <1389702712-26638-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-4-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/14/2014 07:31 AM, Miao Xie wrote:
> There was a problem in the old code:
> If we failed to log the csum, we would free all the ordered extents in the log list
> including those ordered extents that were logged successfully, it would make the
> log committer not to wait for the completion of the ordered extents.
>
> This patch doesn't insert the ordered extents that is about to be logged into
> a global list, instead, we insert them into a local list. If we log the ordered
> extents successfully, we splice them with the global list, or we will throw them
> away, then do full sync. It can also reduce the lock contention and the traverse
> time of list.
>
If we fail to log the csums we'll return an error and commit the 
transaction so it doesn't matter that we free all the ordered extents, 
everything will be waited on properly.  Thanks,

Josef
