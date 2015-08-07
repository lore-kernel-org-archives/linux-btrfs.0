Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37468 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbHGKkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 06:40:25 -0400
Received: by wibhh20 with SMTP id hh20so60262296wib.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 03:40:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1520215.AbHMhTRmNr@hoefnix>
References: <55C47136.2080402@render-wahnsinn.de>
	<201508071918.02231.russell@coker.com.au>
	<1520215.AbHMhTRmNr@hoefnix>
Date: Fri, 7 Aug 2015 11:40:24 +0100
Message-ID: <CAMU1PDjvc-rBFONt9cxyUatFsKHPibid1F--swBAv6MhuVD3FQ@mail.gmail.com>
Subject: Re: btrfs raid1 metadata, single data
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Sjoerd <sjoerd@sjomar.eu>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 August 2015 at 10:47, Sjoerd <sjoerd@sjomar.eu> wrote:
> While we're at it: any idea why the default for SSD's is single for meta data
> as described on the wiki?
> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Filesystem_creation)
>
> I was looking for an answer why my SSD just had single metadata, while I
> expected it to be DUP and stumbled on this wiki article. Can't find a reason
> for why a SSD would be different?
>
> Cheers,
> Sjoerd

I would assume that it is because some SSD drives controllers
deduplicate by default [1].  The developers probably think that when
it comes to your data the truth, no mater how ugly, is preferable to a
false sense of security.  (Btrfs thinking it has 2 copies of metadata
when the SSD drive only actually has stored 1 copy).

[1] How SSDs can hose your data
http://www.zdnet.com/article/how-ssds-can-hose-your-data/
"Researchers found that at least 1 Sandforce SSD controller - the
SF1200 - does block-level deduplication by default. Which can be a
problem.

Many file systems - NTFS, most Unix/Linux FSs, ZFS are some - write
critical metadata to multiple blocks in case one copy gets corrupted.
But what if, unbeknownst to you, your SSD de-duplicates that block,
leaving your file system with only 1 copy? "

Thanks,
Mike
