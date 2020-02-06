Return-Path: <SRS0=9o53=32=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EE0C352A6
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 15:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F3221741
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 15:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZRvO6tb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgBFPLy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:11:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgBFPLn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2020 10:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sH/t7sKgooZyw4hhQwASgl1lHVyEKiY+WTnlFoK032U=; b=rZRvO6tbtr28PMuz9z+MjhgivQ
        6cqL7j2Vxr28BoMoIFHC0+OUtmFBkUT8df6uQRQFyd/SdNDk8CNSQ1qFKkUaLgWMkXLLorWKp2DKz
        NdfzpoPVVLd40MwPL+UxnJaLAy5EVgMD9Ug5o7dzx+zmjj0ot9coY+ZkSiXIP7Lgb/tnWHgs4u7Wn
        0+9ZlhCjB2bOjmScvM/amzPmAvt4CDlD8Tik3QmSgMZdOJIdja68aAz1dmmui1VPJkNWFz1vSjS89
        faN+Ky5b4f0hmtP2eqlspuO4Fva8xaM53si8We1Sh+x4nWIi+U4Sa/y2S48znwsLXsdeHNC0cG4kd
        rKsziq0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izicj-0006WS-3G; Thu, 06 Feb 2020 14:59:21 +0000
Date:   Thu, 6 Feb 2020 06:59:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Sterba <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] btrfs: use BIOs instead of buffer_heads from
 superblock writeout
Message-ID: <20200206145921.GB24780@infradead.org>
References: <20200205143831.13959-1-johannes.thumshirn@wdc.com>
 <20200205143831.13959-3-johannes.thumshirn@wdc.com>
 <20200205181605.GA11348@infradead.org>
 <SN4PR0401MB359893900DDE52857064A2CF9B1D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB359893900DDE52857064A2CF9B1D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 06, 2020 at 08:20:16AM +0000, Johannes Thumshirn wrote:
> >>   		op_flags = REQ_SYNC | REQ_META | REQ_PRIO;
> >>   		if (i == 0 && !btrfs_test_opt(device->fs_info, NOBARRIER))
> >>   			op_flags |= REQ_FUA;
> > 
> >> +		bio->bi_opf = REQ_OP_WRITE | op_flags;
> > 
> > You could kill the op_flags variable and just assign everything directly
> > to bio->bi_opf.
> > 
> 
> Then I'd still have to deal with the NOBARRIER mount option here so 
> op_flags is nice to have for readability.

I tend to disagree.  The simple version is:

		bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO;
		if (i == 0 && !btrfs_test_opt(device->fs_info, NOBARRIER))
			bio->bi_opf |= REQ_FUA;
