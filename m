Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947B3C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 16:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641C620700
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550854448;
	bh=CpNjY6St28RqGrcL0jl9NtWuqPoDilmjmD/38qF4Py8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lRp1OjKtHxBi7ymb5KJCMNXKiv+ajTP73Aq1GN59QcPyB++DeE3N4a0pQGZu09VE6
	 UGgY9sJgz3x44oEQpOzrt7izvWFKIH55vH2MB0jhGtBodyk/m9eN9ZjOifJdcR8dMm
	 +ddEgOxRfGl82pWls7wuHbqXW770seRHsFrkVwVQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfBVQyD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 11:54:03 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40218 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVQyD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 11:54:03 -0500
Received: by mail-yw1-f65.google.com with SMTP id c67so1067337ywa.7;
        Fri, 22 Feb 2019 08:54:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kI5tGxDVTdGcYL9vJ2j2Cz6kTeDPn8/ovqZQNGlFT7g=;
        b=TT1ByVQYKRHC2uU4yT02bUDmV5rnwOsz6rsjyqK08m/wb1PzyShZ1Jw+tlTGyq4eJR
         0ICWjstDUjoZYouzmudmzSz7StmLOBF2kknmLXRtsjlMPOe4cti42UUsA4uwalxnFRb3
         +GFFAsNMX0RG9cmhwhiNg5ZExX91QzwJ1bmnpRnYt/aLytaiUZQsFlVyIXpb5NIZfO9E
         IKqm0QbZS2J8UKx42HYVpDn7aYP1vVbbnf0DCLFey7vnAv1Jy8MgCxhEtkFR98ggRBsn
         tPafjZjaBfIKh6XTjLLYX1jkBU6Fchmh9Cjl4t7/scBsUlCCH9h7YhpFIukPcN7tMAUM
         xDsw==
X-Gm-Message-State: AHQUAubRM5WsBTpYGeb1ujbYrGrgDUw0fn2nkSesDT4fU0MFZNG5uhAa
        BwIFgNKhSzkOLgbtKSludw/WQuMuQkc=
X-Google-Smtp-Source: AHgI3IZsM47FGwnfrMnWYpfD7D5NkbNLsgWdZ5mUwQhorArUAimArjt/zVjaMCg2Rzy8OD2hjQ+R+g==
X-Received: by 2002:a81:59d7:: with SMTP id n206mr3966473ywb.210.1550854442317;
        Fri, 22 Feb 2019 08:54:02 -0800 (PST)
Received: from dennisz-mbp ([2620:10d:c091:200::2:3f98])
        by smtp.gmail.com with ESMTPSA id s186sm760762yws.13.2019.02.22.08.54.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 08:54:00 -0800 (PST)
Date:   Fri, 22 Feb 2019 11:53:57 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: zstd ensure reclaim timer is properly cleaned up
Message-ID: <20190222165357.GA85619@dennisz-mbp>
References: <20190221202556.42447-1-dennis@kernel.org>
 <eb7df5c4-25fb-2d10-58a1-b3be7b37c2db@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb7df5c4-25fb-2d10-58a1-b3be7b37c2db@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 02:17:41PM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.02.19 г. 22:25 ч., Dennis Zhou wrote:
> > The timer function, zstd_reclaim_timer_fn(), reschedules itself under
> > certain conditions. Switch to del_timer_sync() to ensure that the timer
> > function hasn't rescheduled itself.
> 
> According to del_timer_sync it just waits for any concurrent invocation
> to finish. But it's responsibility of the caller to ensure the timer
> cannot really be restarted. It's not obvious how
> zstd_cleanup_workspace_manager ensures that the timer won't be restared.
> Looking at the timer function for it to not restart wsm.lru_list has to
> be empty. And seeing that workspace->lru_list is deleted afterwards I'm
> not sure this invariant holds.
> 

Hmmm, I see. I misunderstood the invariant. I'll spin v2 and handle it
another way.

Thanks,
Dennis

> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> > ---
> >  fs/btrfs/zstd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> > index 3e418a3aeb11..62de9a211321 100644
> > --- a/fs/btrfs/zstd.c
> > +++ b/fs/btrfs/zstd.c
> > @@ -195,7 +195,7 @@ static void zstd_cleanup_workspace_manager(void)
> >  	struct workspace *workspace;
> >  	int i;
> >  
> > -	del_timer(&wsm.timer);
> > +	del_timer_sync(&wsm.timer);
> >  
> >  	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
> >  		while (!list_empty(&wsm.idle_ws[i])) {
> > 
