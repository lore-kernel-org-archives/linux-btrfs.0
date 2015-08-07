Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:45851 "EHLO
	walhalla.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbHGJyX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 05:54:23 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by walhalla.sjomar.eu (Postfix) with ESMTPSA id E7A13100279
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 11:47:58 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 metadata, single data
Date: Fri, 07 Aug 2015 11:47:57 +0200
Message-ID: <1520215.AbHMhTRmNr@hoefnix>
In-Reply-To: <201508071918.02231.russell@coker.com.au>
References: <55C47136.2080402@render-wahnsinn.de> <201508071918.02231.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 07 August 2015 19:18:02 Russell Coker wrote:
> On Fri, 7 Aug 2015 06:49:58 PM Robert Krig wrote:
> > What exactly is contained in btrfs metadata?
> 
> Much the same as in metadata for every other filesystem.
> 
> > I've read about some users setting up their btrfs volumes as
> > data=single, but metadata=raid1
> > 
> > Is there any actual benefit to that? I mean, if you keep your data as
> > single, but have multiple copies of metadata, does that still allow you
> > to recover from data corruption? Or is metadata redundancy a benefit to
> > ensure that your btrfs volume remains mountable/readable?
> 
> If you have redundant metadata and experience corruption then you will know
> the name of every file that has data corruption, this is really good for
> restoring from backup.  Also you will be protected against corruption of a
> root directory causing massive data loss.
> 
> If you have the bad luck to have certain metadata structures corrupted with
> no redundancy then you can face massive data loss and possibly have the
> entire filesystem become at least temporarily unusable.  While corruption
> of the root directory is unlikely it is possible.  With "dup" metadata I've
> seen a BTRFS filesystem remain usable after 12,000+ read errors.

While we're at it: any idea why the default for SSD's is single for meta data 
as described on the wiki? 
(https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Filesystem_creation)

I was looking for an answer why my SSD just had single metadata, while I 
expected it to be DUP and stumbled on this wiki article. Can't find a reason 
for why a SSD would be different?

Cheers,
Sjoerd
 


