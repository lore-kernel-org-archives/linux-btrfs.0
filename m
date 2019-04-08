Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE2BC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 10:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A322920883
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 10:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfDHKrV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 06:47:21 -0400
Received: from verein.lst.de ([213.95.11.211]:42061 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfDHKrV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 06:47:21 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id E120968B02; Mon,  8 Apr 2019 12:47:08 +0200 (CEST)
Date:   Mon, 8 Apr 2019 12:47:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH V2] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190408104708.GA31107@lst.de>
References: <20190407085325.9380-1-ming.lei@redhat.com> <20190408061604.GA26364@lst.de> <20190408083333.GA28939@lst.de> <CACVXFVNkTPf1=6JfO4cYhXwZT9Gg2FVeNh4-VJ3bVUwRw21shA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNkTPf1=6JfO4cYhXwZT9Gg2FVeNh4-VJ3bVUwRw21shA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 04:46:33PM +0800, Ming Lei wrote:
> > Actually..  I just noticed the gratious done rename creates a (trivial)
> > conflict in a series I was about to submit for 5.2.  Can you respin
> > it without the rename to make everyones life a littler easier?
> 
> Yeah, no problem.
> 
> You mean the 'done->bvec_done' rename?

Yes.
