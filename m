Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786B2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46200217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551292167;
	bh=QOK4am8Qc6VAg/+9ho4mo0cR0cKsTgsvzEA0USbJ/Qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vC2bVSJJwzTQij3hvBiN+KNjIGMRts7C3z+BjYhQT9Ea9SHd+GWg5nIz0uOgPyAFu
	 XWJubuTdmnKAF/h0xyPhhhNePfvbZ3vaBulDg7hNZjWGyVL5/+Y+yq1gh3zTCxuOMf
	 ZmA8U+kmX/PBOGXDMH7PVZ6lYSslBsKwg1kxfv6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfB0S3V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:29:21 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41305 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfB0S3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 13:29:21 -0500
Received: by mail-yw1-f66.google.com with SMTP id q128so8901685ywg.8;
        Wed, 27 Feb 2019 10:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sdHjfMAf2z7LN6PM/t5n+j24IpBexjo4WwR4qITpFkE=;
        b=SQOf2HPnUxH/xucqqxlJhKCKZPPZHDuMk3tfcPJKqhl8qr+G8pJ3IdwhL/+XGiZ+AA
         ER5U7JRlky/rY7DRoeQWCwAdH0U1xeo0p6pRDeZxCRgwcpk6l45PwuSd87XcjIV8Gsx3
         9hNAJ7PFfBMnTMZjXhmSOFGv+bdPHjO9bp1jQavqVo0COHLcQf10uqG9QTGqrgw6OoZw
         o66G5qROyJCEqegYxOrOSI8H9LMJtYWPnhtctCOs8CLfY8kkfAmiBHD6yBsaLTI77Mid
         J21kzpyitFD344kNPJBQ2WmyWZ2AseZe5tlE6iP5fxlTq7bBWFy3AzwTvR4HgrZP4D5+
         Lbzg==
X-Gm-Message-State: AHQUAua1QJvGXJyAUzeXU6467hpA9WgT30n2nUCOh6Q01rcTFWYLdX+n
        9FJo64XShNffMBLhBXpfiSo=
X-Google-Smtp-Source: AHgI3IZ+uKhrLcACBOlDGxK/i89B6f0BgtJWu4ESLhegPF1AXLhQ8QUGOOgpya5X0ZEnqQkztD8njw==
X-Received: by 2002:a0d:e401:: with SMTP id n1mr2298766ywe.297.1551292160038;
        Wed, 27 Feb 2019 10:29:20 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::3:8416])
        by smtp.gmail.com with ESMTPSA id x68sm5390876ywd.9.2019.02.27.10.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 10:29:18 -0800 (PST)
Date:   Wed, 27 Feb 2019 13:29:16 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: zstd ensure reclaim timer is properly cleaned
 up
Message-ID: <20190227182916.GA18373@dennisz-mbp.dhcp.thefacebook.com>
References: <20190222195348.2728-1-dennis@kernel.org>
 <20190227164441.GY24609@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227164441.GY24609@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 05:44:41PM +0100, David Sterba wrote:
> On Fri, Feb 22, 2019 at 02:53:48PM -0500, Dennis Zhou wrote:
> > The timer function, zstd_reclaim_timer_fn(), reschedules itself under
> > certain conditions. When cleaning up, take the lock and remove all
> > workspaces. This prevents the timer from rearming itself. Lastly, switch
> > to del_timer_sync() to ensure that the timer function can't trigger as
> > we're unloading.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 

Thanks!

> > ---
> > v2:
> > - cleanup workspaces and then disable the timer
> > 
> >  fs/btrfs/zstd.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> > index 3e418a3aeb11..6b9e29d050f3 100644
> > --- a/fs/btrfs/zstd.c
> > +++ b/fs/btrfs/zstd.c
> > @@ -195,8 +195,7 @@ static void zstd_cleanup_workspace_manager(void)
> >  	struct workspace *workspace;
> >  	int i;
> >  
> > -	del_timer(&wsm.timer);
> > -
> > +	spin_lock(&wsm.lock);
> >  	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
> >  		while (!list_empty(&wsm.idle_ws[i])) {
> >  			workspace = container_of(wsm.idle_ws[i].next,
> > @@ -206,6 +205,9 @@ static void zstd_cleanup_workspace_manager(void)
> >  			wsm.ops->free_workspace(&workspace->list);
> 
> I've noticed while reading the code, why do you use the indirect call
> here? The wsm.ops points to btrfs_zstd_compress so free_workspace is
> always zstd_free_workspace.
> 
> The compiler is usually smart to replace such things by direct call if
> the type has not escaped, but this is not true for btrfs_compress_op so
> the indirect function call must be preserved.

I don't have a strong reason to use the indirect call here. It was just
to make it consistent for everyone to use the indirection. This at least
is in the cleanup path, so I don't think performance is that important?
But I don't feel strongly for or against calling zstd_free_workspace()
directly.

Thanks,
Dennis
