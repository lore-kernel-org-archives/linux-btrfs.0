Return-Path: <SRS0=2F5/=2C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7E5C43603
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8E8321556
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbfLLWYL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 17:24:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:58434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730868AbfLLWYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Dec 2019 17:24:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10FC6ACF1;
        Thu, 12 Dec 2019 22:24:09 +0000 (UTC)
Date:   Thu, 12 Dec 2019 16:24:06 -0600
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, fdmanana@kernel.org, dsterba@suse.cz,
        jthumshirn@suse.de, nborisov@suse.com
Subject: Re: [PATCH 4/8] iomap: Move lockdep_assert_held() to iomap_dio_rw()
 calls
Message-ID: <20191212222405.oaceuk63cme2mlkz@fiona>
References: <20191212003043.31093-1-rgoldwyn@suse.de>
 <20191212003043.31093-5-rgoldwyn@suse.de>
 <20191212095044.GD15977@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212095044.GD15977@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  1:50 12/12, Christoph Hellwig wrote:
> On Wed, Dec 11, 2019 at 06:30:39PM -0600, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > Filesystems such as btrfs can perform direct I/O without holding the
> > inode->i_rwsem in some of the cases like writing within i_size.
> 
> How is that safe? 

This (inode_lock release) is only done for writes within i_size.
We only have to safeguard write against truncates, which is done by
inode_dio_wait() call in the truncate sequence (I had mistakenly removed
it in patch 8/8, I shall reinstate that). The commit that introduced this
optimization is 38851cc19adb ("Btrfs: implement unlocked dio write")


> 
> > +	lockdep_assert_held(&file_inode(file)->i_rwsem);
> 
> Having the asserts in the callers is pointless.  The assert is inside
> the iomap helper to ensure the expected calling conventions, as the
> code is written under the assumption that we have i_rwsem.

Hmm, conflicting opinions from you and Dave. Anyways, I have removed it
in individual filesystems.

-- 
Goldwyn
