Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C225C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA03520857
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfDAUnf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 16:43:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:60506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbfDAUne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 16:43:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4125BAEA9;
        Mon,  1 Apr 2019 20:43:32 +0000 (UTC)
Date:   Mon, 1 Apr 2019 15:43:30 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190401204330.iaiyqvhaydkdjvrr@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190328172825.GQ29086@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328172825.GQ29086@twin.jikos.cz>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 18:28 28/03, David Sterba wrote:
> On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > This sets S_DAX in inode->i_flags, which can be used with
> > IS_DAX().
> > 
> > The dax option is restricted to non multi-device mounts.
> > dax interacts with the device directly instead of using bio, so
> > all bio-hooks which we use for multi-device cannot be performed
> > here. While regular read/writes could be manipulated with
> > RAID0/1, mmap() is still an issue.
> 
> I'm looking for other features that would not work with dax. Disabling
> multiple devices strikes out device add, device delete and device
> replace.

I am glad you brought this up.
> 
> To be verified:
> 
> - balance - at least profile changes must be forbidden
> 
> - defrag

Disabled for now with EOPNOTSUPP primarily because of (null) readpages()
in dax.

> 
> - compression - as it needs COW, it won't work on the nodatacow files,
>   thus seems to be ok

Compression would require some sort of processing before writes. However,
users are writing directly to disk. So no, this can't be supported either.

> 
> - resize/grow - this could work without changes, no block relocation is
>   needed, only new structures created
> 
> - resize/shrink - depends on balance, the block groups from the removed
>   area need to be relocated
> 
> - swapfiles - I'm sure somebody will try that; I haven't seen any
>   IS_DAX checks in the swapfile activation code

-- 
Goldwyn
