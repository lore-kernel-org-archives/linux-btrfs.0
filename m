Return-Path: <SRS0=AUj1=6E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E1DC3815B
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Apr 2020 15:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D42206DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Apr 2020 15:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgDTPqe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 11:46:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:49498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDTPqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Apr 2020 11:46:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 65F28AD49;
        Mon, 20 Apr 2020 15:46:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C3349DA72D; Mon, 20 Apr 2020 17:45:50 +0200 (CEST)
Date:   Mon, 20 Apr 2020 17:45:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Omar Sandoval <osandov@osandov.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 03/15] btrfs: fix double __endio_write_update_ordered
 in direct I/O
Message-ID: <20200420154550.GE18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Omar Sandoval <osandov@osandov.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
References: <cover.1587072977.git.osandov@fb.com>
 <594c8cb6dd64cebdf5e01016ce823e1be00fc7ab.1587072977.git.osandov@fb.com>
 <SN4PR0401MB3598FE83B98A4D727852D6179BD90@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598FE83B98A4D727852D6179BD90@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 17, 2020 at 05:53:49PM +0000, Johannes Thumshirn wrote:
> On 16/04/2020 23:47, Omar Sandoval wrote:
> [...]
> > +static struct btrfs_dio_private *btrfs_create_dio_private(struct bio *dio_bio,
> > +							  struct inode *inode,
> > +							  loff_t file_offset)
> >   {
> > -	struct inode *inode = dip->inode;
> > +	const bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
> 
> Nit: I think the braces aren't needed here.

For readability I prefer to keep them, it makes the operator precedence
obvious.
