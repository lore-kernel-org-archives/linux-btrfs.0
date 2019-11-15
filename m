Return-Path: <SRS0=NtSv=ZH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ADAC43141
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 20:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66816206D9
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 20:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKOULN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 15:11:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:47682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbfKOULN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Nov 2019 15:11:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8B46B02C;
        Fri, 15 Nov 2019 20:11:11 +0000 (UTC)
Date:   Fri, 15 Nov 2019 14:11:09 -0600
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH 3/7] iomap: use a function pointer for dio submits
Message-ID: <20191115201109.nj3agxiqs46off3d@fiona>
References: <20191115161700.12305-1-rgoldwyn@suse.de>
 <20191115161700.12305-4-rgoldwyn@suse.de>
 <20191115164708.GB26016@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115164708.GB26016@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  8:47 15/11, Christoph Hellwig wrote:
> The subject is a little odd, as we only optionally override submit_bio.
> Maybe something like:
> 
> iomap: add a file system hook for direct I/O bio submission
> 
> On Fri, Nov 15, 2019 at 10:16:56AM -0600, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > This helps filesystems to perform tasks on the bio while
> > submitting for I/O. This could be post-write operations
> > such as data CRC or data replication for fs-handled RAID.
> 
> You can use up to 73 chars for the commit log.
> 
> > +	if (dio->dops && dio->dops->submit_io)
> > +		dio->submit.cookie = dio->dops->submit_io(bio,
> > +				file_inode(dio->iocb->ki_filp),	pos);
> 
> Any reason to not simply pass the file?

No, I just didn't change the original btrfs_submit_direct(). Passing
filp will be much neater. I will incorporate this.

I agree with all of your comments, and will implement them in the next
patchset.

-- 
Goldwyn
