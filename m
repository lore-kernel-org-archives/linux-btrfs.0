Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BE4C43334
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Jul 2022 13:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiGGNaO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiGGNaO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2022 09:30:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F202E6B0
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2022 06:30:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A136B67373; Thu,  7 Jul 2022 15:30:08 +0200 (CEST)
Date:   Thu, 7 Jul 2022 15:30:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: fix repair of compressed extents
Message-ID: <20220707133008.GA18415@lst.de>
References: <20220630160130.2550001-1-hch@lst.de> <20220630160130.2550001-5-hch@lst.de> <f8773669-79a7-6cbc-4c70-b805527b3268@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8773669-79a7-6cbc-4c70-b805527b3268@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 07, 2022 at 03:50:34PM +0300, Nikolay Borisov wrote:
>> +	btrfs_bio_for_each_sector(fs_info, bv, bbio, iter, offset) {
>> +		u64 start = bbio->file_offset + offset;
>> +
>> +		if (!status &&
>> +		    (!csum || !check_data_csum(inode, bbio, offset, bv.bv_page,
>> +					       bv.bv_offset))) {
>
> In the !csum case you'd be executing a lot of code for no gain i.e 
> clean_io_failure. Instead, factor out the !csum case as a break from the 
> btrfs_bio_for_each_sector i.e no point in running clean_io_failure for 
> every sector in this case.

We still need to call clean_io_failure in that case, as repair can
also happen when I/O failed even without checksums.  Note that this
code also is just a copy and paste from the direct I/O completion
handler, and an equivalent but more obsfucated version of same
logic also exists in the buffered I/O completion path.

(and before anyone asks, I do have a WIP patchset to consolidate the
logic, and remove the calls to clean_io_failure for non-repair bio
completions, but it will take a while to get there).

>> -	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
>> +	cb = kmalloc(sizeof(struct compressed_bio), GFP_NOFS);
>
> nit: This change is irrelevant to this patch - indeed we don't need to 
> allocate the flex array at the end of compressed_bio for writes, as the 
> csums are being stored in the ordered extents for the bio, still this it's 
> independent of this patch.

True.
