Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34483 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbaCSQuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 12:50:37 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 19 Mar 2014 22:20:35 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 2394BE0058
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 22:24:27 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2JGoTDx4325860
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 22:20:29 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2JGoWoS007792
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 22:20:33 +0530
From: chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH 1/6] Btrfs: subpagesize-blocksize: Get rid of whole page reads.
Date: Wed, 19 Mar 2014 22:20:31 +0630
Message-ID: <2116637.vUjb1dxbY0@localhost.localdomain>
In-Reply-To: <20140319073734.GC21531@localhost.localdomain>
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com> <1394634033-2528-2-git-send-email-chandan@linux.vnet.ibm.com> <20140319073734.GC21531@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> These should be put in front of "struct bio bio",
> otherwise, it might lead to errors, according to bioset_create()'s comments,
> 
> ----------------------------------------------------------------------
> "Note that the bio must be embedded at the END of that structure always,    
> or things will break badly."
> ----------------------------------------------------------------------
> 

Thank you for pointing that out. I will fix it.

Thanks,
chandan

