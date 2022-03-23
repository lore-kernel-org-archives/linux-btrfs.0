Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CDCC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 08:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242451AbiCWINC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 04:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiCWINA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Mar 2022 04:13:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF8343AC5;
        Wed, 23 Mar 2022 01:11:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 688EB68B05; Wed, 23 Mar 2022 09:11:28 +0100 (CET)
Date:   Wed, 23 Mar 2022 09:11:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 40/40] btrfs: use the iomap direct I/O bio directly
Message-ID: <20220323081128.GA26391@lst.de>
References: <20220322155606.1267165-1-hch@lst.de> <20220322155606.1267165-41-hch@lst.de> <37a6e06f-c8ac-37dc-2f3b-b469e2410a97@gmx.com> <20220323061756.GA24589@lst.de> <58f9eaad-e857-7619-dfd3-318ae71448d2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58f9eaad-e857-7619-dfd3-318ae71448d2@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 04:02:34PM +0800, Qu Wenruo wrote:
> A little curious if there will be other users of this other than btrfs.
>
> I guess for XFS/EXT4 they don't need any extra space and can just submit
> the generic bio directly to their devices?

For normal I/O, yes.  But if we want to use Zone Append we'll basically
need to use this kind of hook everywhere. 

>>> Personally speaking I didn't see much problem of cloning an iomap bio,
>>> it only causes extra memory of btrfs_bio, which is pretty small previously.
>>
>> It is yet another pointless memory allocation in something considered very
>> much a fast path.
>
> Another concern is, this behavior mostly means we don't split the
> generic bio.
> Or we still need to allocate memory for the btrfs specific memory for
> the new bio.

With the current series we never split it, yes.  I'm relatively new
to btrfs, so why would we want to split the bio anyway?

As far as I can tell this is only done for parity raid, and maybe
we could actually do the split for those with just this scheme.

I.e. do what you are doing in your series in btrfs_map_bio and
allow to clone partial bios there, which should still be possible
threre.  We'd still need the high-level btrfs_bio to contain the
mapping and various end I/O infrastructure like the btrfs_work.

