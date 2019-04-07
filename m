Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1242C282DE
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C2E218CD
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfDGHiZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:38:25 -0400
Received: from verein.lst.de ([213.95.11.211]:35920 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfDGHiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Apr 2019 03:38:25 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 89EDD68B02; Sun,  7 Apr 2019 09:38:13 +0200 (CEST)
Date:   Sun, 7 Apr 2019 09:38:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190407073813.GA9704@lst.de>
References: <20190406215428.3131-1-ming.lei@redhat.com> <20190407065205.GA8799@lst.de> <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Apr 07, 2019 at 03:37:00PM +0800, Ming Lei wrote:
> > > @@ -48,7 +48,7 @@ struct bvec_iter {
> > >  struct bvec_iter_all {
> > >       struct bio_vec  bv;
> > >       int             idx;
> > > -     unsigned        done;
> > > +     unsigned        bv_done;
> >
> > Why the rename here?
> 
> 'done' may be a bit misleading given we know this field is for recording how
> many bytes we have done on the current bvec. Or .bvec_done?

I doubt add a comment..
