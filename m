Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52026 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaILUCf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 16:02:35 -0400
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8CJxZ0X006627
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:02:35 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pc2bv8pqu-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:02:35 -0700
Message-ID: <54135157.1050001@fb.com>
Date: Fri, 12 Sep 2014 16:02:31 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove empty block groups automatically
References: <1410549510-22336-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1410549510-22336-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/12/2014 03:18 PM, Josef Bacik wrote:
> One problem that has plagued us is that a user will use up all of his space with
> data, remove a bunch of that data, and then try to create a bunch of small files
> and run out of space.  This happens because all the chunks were allocated for
> data since the metadata requirements were so low.  But now there's a bunch of
> empty data block groups and not enough metadata space to do anything.  This
> patch solves this problem by automatically deleting empty block groups.  If we
> notice the used count go down to 0 when deleting or on mount notice that a block
> group has a used count of 0 then we will queue it to be deleted.
> 
> When the cleaner thread runs we will double check to make sure the block group
> is still empty and then we will delete it.  This patch has the side effect of no
> longer having a bunch of BUG_ON()'s in the chunk delete code, which will be
> helpful for both this and relocate.  Thanks,

Thanks Josef, we've needed this forever.  I'm planning on pulling it in
for integration as well.

-chris
