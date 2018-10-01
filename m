Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC47C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 16:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C119213A2
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 16:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C119213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbeJAX1P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:27:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:60892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbeJAX1P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 19:27:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECB09AEE1;
        Mon,  1 Oct 2018 16:48:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B76CBDAD55; Mon,  1 Oct 2018 18:48:31 +0200 (CEST)
Date:   Mon, 1 Oct 2018 18:48:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     zhong jiang <zhongjiang@huawei.com>, dsterba@suse.com,
        jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: list usage cleanup
Message-ID: <20181001164831.GS3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        zhong jiang <zhongjiang@huawei.com>, dsterba@suse.com,
        jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1537950945-5627-1-git-send-email-zhongjiang@huawei.com>
 <20180927184704.GA29754@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927184704.GA29754@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 27, 2018 at 11:47:04AM -0700, Omar Sandoval wrote:
> On Wed, Sep 26, 2018 at 04:35:45PM +0800, zhong jiang wrote:
> > Trival cleanup, list_move_tail will implement the same function that
> > list_del() + list_add_tail() will do. hence just replace them.
> > 
> > Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> > ---
> >  fs/btrfs/send.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index 094cc144..d87f416 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -2075,8 +2075,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
> >   */
> >  static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
> >  {
> > -	list_del(&nce->list);
> > -	list_add_tail(&nce->list, &sctx->name_cache_list);
> > +	list_move_tail(&nce->list, &sctx->name_cache_list);
> >  }
> 
> At that point do we even need such a trivial helper, considering that
> this is only called in one place?

Fair point and trivial one-line helpers are on the cleanup todo list.
The exception is when the actual helper implementation is obscuring the
semantics and the helper is used in many places so it's not practical to
add a comment everywhere. But it's not the case here.

Zhong Jiang, please update the patch and resend, thanks.
