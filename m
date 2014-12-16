Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55908 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaLPUQj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 15:16:39 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBGKGYCX006107
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 12:16:38 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1radkthsc5-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 12:16:38 -0800
Message-ID: <54909312.6090901@fb.com>
Date: Tue, 16 Dec 2014 15:16:18 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't delete csum for free space cache
References: <1418418042-1105-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1418418042-1105-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 04:00 PM, Josef Bacik wrote:
> We unconditionally delete csums for data extents, but we don't have csums for
> free space cache, so all this does is force us to recow the csum root, which
> will cause us to re-write the block group cache.  This patch fixes this by
> noticing if we're a free space cache extent and simply skipping the delete csum
> step.  Thanks,
>

I'm axe'ing this patch.  Thanks,

Josef

