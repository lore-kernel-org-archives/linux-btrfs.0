Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48064 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbbL2KMC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 05:12:02 -0500
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Dec 2015 20:11:58 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id BC0A7357804F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 21:11:56 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBTABmUq459074
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 21:11:56 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBTABO3P008682
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 21:11:24 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] btrfs: Enhance chunk validation check
Date: Tue, 29 Dec 2015 15:41:04 +0530
Message-ID: <3370608.49fr4JG5K4@localhost.localdomain>
In-Reply-To: <1449564042-5473-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1449564042-5473-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 Dec 2015 16:40:42 Qu Wenruo wrote:
> Enhance chunk validation:
> 1) Num_stripes
>    We already have such check but it's only in super block sys chunk
>    array.
>    Now check all on-disk chunks.
> 
> 2) Chunk logical
>    It should be aligned to sector size.
>    This behavior should be *DOUBLE CHECKED* for 64K sector size like
>    PPC64 or AArch64.
>    Maybe we can found some hidden bugs.
> 

Sorry about the delayed response. I executed fstests on ppc64 with 64k block
size and all the tests that used to pass earlier (i.e. without patch applied)
continue to pass. Hence,

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

