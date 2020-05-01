Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5FDC4724C
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3CB214D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588314647;
	bh=MJTLu1cJAHN/uBGEMZzaAEqBgoS//oQBGNisllNh6fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YCg++vQC2vVJUPuw5r9itmP8tyQKc7aLe3fNcvazUKJw1r+C1Ai9RyLRnJeUlOCwf
	 HGf+0T0jNv7V4vBFL3QR4wggLFA7XqoRKMeczYnRkQoU35/cOiOxZ0w9lwTlJbAYbl
	 ASdtpbPJ7AYL5zWtVQvSehXajCzfosKhgzixRrhM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgEAGaq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgEAGap (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 02:30:45 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D927A208C3;
        Fri,  1 May 2020 06:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588314645;
        bh=MJTLu1cJAHN/uBGEMZzaAEqBgoS//oQBGNisllNh6fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmohH6JF597Rj3VBcENhxfZskISJDvXqKGnZUWK0d92GBsFzuk97DMn8SjGNS3T8N
         TmiSsEZmtj5LmmVW+CzG2wJX9FMI1mUC6vRdXDqyNdt32zS7hnQOINVuNM1mdWsFRj
         3c+GdnWv+JHnrJOD9ZOQkRAXbRZbMxAF/l8KOd9s=
Date:   Thu, 30 Apr 2020 23:30:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 1/2] btrfs: add authentication support
Message-ID: <20200501063043.GE1003@sol.localdomain>
References: <20200428105859.4719-1-jth@kernel.org>
 <20200428105859.4719-2-jth@kernel.org>
 <20200501053908.GC1003@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501053908.GC1003@sol.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 30, 2020 at 10:39:08PM -0700, Eric Biggers wrote:
> On Tue, Apr 28, 2020 at 12:58:58PM +0200, Johannes Thumshirn wrote:
> > From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > 
> > Add authentication support for a BTRFS file-system.
> > 
> > This works, because in BTRFS every meta-data block as well as every
> > data-block has a own checksum. For meta-data the checksum is in the
> > meta-data node itself. For data blocks, the checksums are stored in the
> > checksum tree.
> > 
> > When replacing the checksum algorithm with a keyed hash, like HMAC(SHA256),
> > a key is needed to mount a verified file-system. This key also needs to be
> > used at file-system creation time.
> > 
> > We have to used a keyed hash scheme, in contrast to doing a normal
> > cryptographic hash, to guarantee integrity of the file system, as a
> > potential attacker could just replay file-system operations and the
> > changes would go unnoticed.
> > 
> > Having a keyed hash only on the topmost Node of a tree or even just in the
> > super-block and using cryptographic hashes on the normal meta-data nodes
> > and checksum tree entries doesn't work either, as the BTRFS B-Tree's Nodes
> > do not include the checksums of their respective child nodes, but only the
> > block pointers and offsets where to find them on disk.
> > 
> > Also note, we do not need a incompat R/O flag for this, because if an old
> > kernel tries to mount an authenticated file-system it will fail the
> > initial checksum type verification and thus refuses to mount.
> > 
> > The key has to be supplied by the kernel's keyring and the method of
> > getting the key securely into the kernel is not subject of this patch.
> 
> This is a good idea, but can you explain exactly what security properties you
> aim to achieve?
> 
> As far as I can tell, btrfs hashes each data block individually.  There's no
> contextual information about where eaech block is located or which file(s) it
> belongs to.  So, with this proposal, an attacker can still replace any data
> block with any other data block.  Is that what you have in mind?  Have you
> considered including contextual information in the hashes, to prevent this?
> 
> What about metadata blocks -- how well are they authenticated?  Can they be
> moved around?  And does this proposal authenticate *everything* on the
> filesystem, or is there any part that is missed?  What about the superblock?
> 
> You also mentioned preventing replay of filesystem operations, which suggests
> you're trying to achieve rollback protection.  But actually this scheme doesn't
> provide rollback protection.  For one, an attacker can always just rollback the
> entire filesystem to a previous state.
> 
> This feature would still be useful even with the above limitations.  But what is
> your goal exactly?  Can this be made better?

btrfs also has an inode flag BTRFS_INODE_NODATASUM, which looks scary as it
results in the file being unauthenticated.  Presumably the authentication of the
filesystem metadata is supposed to prevent this flag from being maliciously
cleared?  It might be a good idea to forbid this flag if the filesystem is using
the authentication feature.

- Eric
