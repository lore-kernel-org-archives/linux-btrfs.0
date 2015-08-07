Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:43768 "EHLO
	walhalla.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbbHGUHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 16:07:49 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by walhalla.sjomar.eu (Postfix) with ESMTPSA id 1A2C8100573
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 22:07:44 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 metadata, single data
Date: Fri, 07 Aug 2015 22:07:44 +0200
Message-ID: <3420345.ZbC7yzDDA0@hoefnix>
In-Reply-To: <CAMU1PDjvc-rBFONt9cxyUatFsKHPibid1F--swBAv6MhuVD3FQ@mail.gmail.com>
References: <55C47136.2080402@render-wahnsinn.de> <1520215.AbHMhTRmNr@hoefnix> <CAMU1PDjvc-rBFONt9cxyUatFsKHPibid1F--swBAv6MhuVD3FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 07 August 2015 11:40:24 Mike Fleetwood wrote:
> On 7 August 2015 at 10:47, Sjoerd <sjoerd@sjomar.eu> wrote:
> > While we're at it: any idea why the default for SSD's is single for meta
> > data as described on the wiki?
> > (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> > #Filesystem_creation)
> > 
> > I was looking for an answer why my SSD just had single metadata, while I
> > expected it to be DUP and stumbled on this wiki article. Can't find a
> > reason for why a SSD would be different?
> > 
> > Cheers,
> > Sjoerd
> 
> I would assume that it is because some SSD drives controllers
> deduplicate by default [1].  The developers probably think that when
> it comes to your data the truth, no mater how ugly, is preferable to a
> false sense of security.  (Btrfs thinking it has 2 copies of metadata
> when the SSD drive only actually has stored 1 copy).
> 
> [1] How SSDs can hose your data
> http://www.zdnet.com/article/how-ssds-can-hose-your-data/
> "Researchers found that at least 1 Sandforce SSD controller - the
> SF1200 - does block-level deduplication by default. Which can be a
> problem.
> 
> Many file systems - NTFS, most Unix/Linux FSs, ZFS are some - write
> critical metadata to multiple blocks in case one copy gets corrupted.
> But what if, unbeknownst to you, your SSD de-duplicates that block,
> leaving your file system with only 1 copy? "
> 
> Thanks,
> Mike

Thanks for the explanation Mike...sounds plausible..
