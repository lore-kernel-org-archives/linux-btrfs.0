Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46046 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbJBMZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 08:25:17 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 2 Oct 2015 22:25:14 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 6311D2BB0057
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 22:25:11 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t92CP4F638797382
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 22:25:12 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t92COcKe025897
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 22:24:38 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, bo.li.liu@oracle.com,
        dsterba@suse.cz, quwenruo@cn.fujitsu.com, chandan@mykolab.com,
        jpa@semihalf.com
Subject: Re: [PATCH V5 12/13] Btrfs: prepare_pages: Retry adding a page to the page cache
Date: Fri, 02 Oct 2015 17:54:19 +0530
Message-ID: <1796383.HbmoRglGMS@localhost.localdomain>
In-Reply-To: <560D4836.8020301@fb.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com> <1443608912-31667-13-git-send-email-chandan@linux.vnet.ibm.com> <560D4836.8020301@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 Oct 2015 10:50:30 Josef Bacik wrote:
> On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> > When reading the page from the disk, we can race with Direct I/O which can
> > get the page lock (before prepare_uptodate_page() gets it) and can go
> > ahead and invalidate the page. Hence if the page is not found in the
> > inode's address space, retry the operation of getting a page.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> 
> Huh, how in the world did you make that happen?
>

The issue is seen when generic/095 test is run in a loop. I would like to add,

Reported-by: Jakub Palider <jpa@semihalf.com>

> Reviewed-by: Josef Bacik <jbacik@fb.com>
> 
> Thanks,
> 
> Josef

-- 
chandan

