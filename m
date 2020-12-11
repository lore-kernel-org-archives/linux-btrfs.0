Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC598C433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE31223DC2
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406575AbgLKQM6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394744AbgLKQMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Dec 2020 11:12:45 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AFCC0613CF
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2020 08:12:01 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 11so7270018pfu.4
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2020 08:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dF/+QWTS4vcYa6r8HIT3CL4spNlyter2NRntzpQQEHY=;
        b=C7p5Su3RYcN6Fl9JK3Ce5m+w+fUgG/vZeAvCfp0s9NSIA1WFOhfcIvm94lFyI8dM7D
         ixxKEdrK1feSo0YpRn4Pe7EPIT067Nt4jPTkTCa9mSwzGMrr5brXs51mvW6GJy8rGmDV
         Anttc+NAHc5SseCX+YjhaPJzAboHuG+0IzVW/xVD+XtT0LPufaHNjWtvTtuIOVbkZ/iI
         t8rGVrZiI6opzfXwSxn6qJ4lJyxyvAwVoD0aGpgmkrEqxu6o2+vvmwWxMa+3SMrOO71Y
         oPA6+APIkX48YmLpZ5RVxWV2Uvf5GZrjEIyN6flNFYUx9Kyva9Fo5QD86a1TmKJfCjJc
         N4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dF/+QWTS4vcYa6r8HIT3CL4spNlyter2NRntzpQQEHY=;
        b=OYiAI3IOo0HqminL/bbGO1slc6wf7QX2kFx4yQVA0ec3+9S/4dvcTAZgnWzfSAEUYD
         R6pdg9IGrdGmLZWzCYdBPTPkXk2Iok7fCGQtTo4h6s07081etLCP3roZPmASOTvT9yCu
         ZW9u2+JtExLrl88R7jTo8CPc9slJ56AHDW7sJjL5rvCdZBQx5FgzjAIItRfghCl4eg4k
         eCOEtSa/XuoIs8AuaYrRtBxx/9+Vvt+abyjxZgnPcSCORI7bpCWdN1nAQD305iHH3sEU
         Mb/FmG73UA9NMCyyQil0S9oxpj2/5z51M12coQnU/bIGT650UuMTObLS1PsIGVqvpSTW
         r5yA==
X-Gm-Message-State: AOAM533z9Kcxc66CYiMYnHqLxfjeNCVwJOdkiyXTnwjCX8BAOIovvdZG
        O4LJQOfqNVGJvavqieW+5pE=
X-Google-Smtp-Source: ABdhPJz9Ot7Ji7GgR04IZKA+cXe/HJlwiaH7NSGy0dH+PRCxj+FQHdej7zR/IWQcQ0Yo7KQoOPKn/Q==
X-Received: by 2002:a62:88c3:0:b029:18c:3203:efb7 with SMTP id l186-20020a6288c30000b029018c3203efb7mr12098278pfd.33.1607703121239;
        Fri, 11 Dec 2020 08:12:01 -0800 (PST)
Received: from realwakka ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id p21sm2706980pjz.14.2020.12.11.08.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:12:00 -0800 (PST)
Date:   Fri, 11 Dec 2020 16:11:50 +0000
From:   Sidong Yang <realwakka@gmail.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: common: introduce
 fmt_print_start_object
Message-ID: <20201211161150.GA456927@realwakka>
References: <20201111163909.3968-1-realwakka@gmail.com>
 <20201210202846.GI6430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210202846.GI6430@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 10, 2020 at 09:28:47PM +0100, David Sterba wrote:
> On Wed, Nov 11, 2020 at 04:39:08PM +0000, Sidong Yang wrote:
> > Introduce a new function that can be used when you need to print an json
> > object in command like "device stats".
> > 
> > Signed-off-by: Sidong Yang <realwakka@gmail.com>
> > ---
> >  common/format-output.c | 20 ++++++++++++++++++++
> >  common/format-output.h |  3 +++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/common/format-output.c b/common/format-output.c
> > index 8df93ecb..f31e7259 100644
> > --- a/common/format-output.c
> > +++ b/common/format-output.c
> > @@ -213,6 +213,26 @@ void fmt_print_end_group(struct format_ctx *fctx, const char *name)
> >  	}
> >  }
> >  
> > +void fmt_print_start_object(struct format_ctx *fctx)
> > +{
> > +	if (bconf.output_format == CMD_FORMAT_JSON) {
> > +		fmt_separator(fctx);
> > +		fmt_inc_depth(fctx);
> > +		fctx->memb[fctx->depth] = 0;
> > +		putchar('{');
> > +	}
> > +}

Hi David. Thanks for review.
> 
> This duplicates what fmt_print_start_group and fmt_print_end_group do,
> so these should be extended to handle when 'name' is NULL and print only
> the [ or {.

I think it's good to extend fmt_print_start_group. I'll retry with it.

Thanks,
Sidong
