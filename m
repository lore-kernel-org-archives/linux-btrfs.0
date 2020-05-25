Return-Path: <SRS0=6Gfh=7H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB645C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 13:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A72032071A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 13:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390674AbgEYNLk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 May 2020 09:11:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37898 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388738AbgEYNLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 May 2020 09:11:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6066AAC46;
        Mon, 25 May 2020 13:11:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0A66DA728; Mon, 25 May 2020 15:10:40 +0200 (CEST)
Date:   Mon, 25 May 2020 15:10:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3 0/3] Add file-system authentication to BTRFS
Message-ID: <20200525131040.GS18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jth@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20200514092415.5389-1-jth@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514092415.5389-1-jth@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 14, 2020 at 11:24:12AM +0200, Johannes Thumshirn wrote:
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> This series adds file-system authentication to BTRFS. 
> 
> Unlike other verified file-system techniques like fs-verity the
> authenticated version of BTRFS does not need extra meta-data on disk.
> 
> This works because in BTRFS every on-disk block has a checksum, for meta-data
> the checksum is in the header of each meta-data item. For data blocks, a
> separate checksum tree exists, which holds the checksums for each block.
> 
> Currently BRTFS supports CRC32C, XXHASH64, SHA256 and Blake2b for checksumming
> these blocks. This series adds a new checksum algorithm, HMAC(SHA-256), which
> does need an authentication key. When no, or an incoreect authentication key
> is supplied no valid checksum can be generated and a read, fsck or scrub
> operation would detect invalid or tampered blocks once the file-system is
> mounted again with the correct key. 

As mentioned in the discussion under LWN article, https://lwn.net/Articles/818842/
ZFS implements split hash where one half is (partial) authenticated hash
and the other half is a checksum. This allows to have at least some sort
of verification when the auth key is not available. This applies to the
fixed size checksum area of metadata blocks, for data we can afford to
store both hashes in full.

I like this idea, however it brings interesting design decisions, "what
if" and corner cases:

- what hashes to use for the plain checksum, and thus what's the split
- what if one hash matches and the other not
- increased checksum calculation time due to doubled block read
- whether to store the same parital hash+checksum for data too

As the authenticated hash is the main usecase, I'd reserve most of the
32 byte buffer to it and use a weak hash for checksum: 24 bytes for HMAC
and 8 bytes for checksum. As an example: sha256+xxhash or
blake2b+xxhash.

I'd outright skip crc32c for the checksum so we have only small number
of authenticated checksums and avoid too many options, eg.
hmac-sha256-crc32c etc. The result will be still 2 authenticated hashes
with the added checksum hardcoded to xxhash.
