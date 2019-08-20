Return-Path: <SRS0=ZmOe=WQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA04C3A589
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFAD820673
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfHTOe4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:34:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:51872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730029AbfHTOe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Aug 2019 10:34:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5240ACC2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2019 14:34:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 182D7DA7DA; Tue, 20 Aug 2019 16:35:22 +0200 (CEST)
Date:   Tue, 20 Aug 2019 16:35:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: define compression levels statically
Message-ID: <20190820143521.GT24086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1565362438.git.dsterba@suse.com>
 <78207f6784c457dad6583f7bc7eecc495c7d5d54.1565362438.git.dsterba@suse.com>
 <ae30ae87-0e4a-af31-5a58-b32e7364588e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae30ae87-0e4a-af31-5a58-b32e7364588e@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 12, 2019 at 11:30:42AM +0300, Nikolay Borisov wrote:
> 
> 
> On 9.08.19 г. 17:55 ч., David Sterba wrote:
> > The maximum and default levels do not change and can be defined
> > directly. The set_level callback was a temporary solution and will be
> > removed.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/compression.h | 4 ++++
> >  fs/btrfs/lzo.c         | 2 ++
> >  fs/btrfs/zlib.c        | 2 ++
> >  fs/btrfs/zstd.c        | 2 ++
> >  4 files changed, 10 insertions(+)
> > 
> > diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> > index 2035b8eb1290..07b2009dc63f 100644
> > --- a/fs/btrfs/compression.h
> > +++ b/fs/btrfs/compression.h
> > @@ -162,6 +162,10 @@ struct btrfs_compress_op {
> >  	 * if the level is out of bounds or the default if 0 is passed in.
> >  	 */
> >  	unsigned int (*set_level)(unsigned int level);
> > +
> > +	/* Maximum level supported by the compression algorithm */
> > +	int max_level;
> > +	int default_level;
> 
> can levels be negative? If not just define those as unsigned ints and in
> the next patch it won't be necessary to use min_t but plain min.

No, levels should be >= 0.
