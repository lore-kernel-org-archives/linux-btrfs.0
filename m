Return-Path: <SRS0=nkCz=4L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51531C35673
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EC822525
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3wlshSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgBWM5N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 07:57:13 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43591 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgBWM5N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Feb 2020 07:57:13 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so3822434pfh.10;
        Sun, 23 Feb 2020 04:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yRkJJfDJ1hFPMppUtn11BxgK0MvTcayru+8IH/S3SHM=;
        b=A3wlshSpQp4lpv0hDjqqvcSziSL0Ugs1O1K1WUz5hlm73jL93j+k6tANWMZmjpRysZ
         5WLzoa0hf894AqoQbuM6ce1XuSd2WX+HNTANaNv/z3noleGTMh3cm3M+ChDyJ4EIyG+Z
         FuWqsIbfa6I296Nz3eM7ODVH4oFrB6brFLO+AdDGGc9rzqGSZNda+BYGaNrnqUvdf7pC
         5gRUw9xn59qrSYYAC1Qomu7rQaDrl67Tymopwm8P+Kl6gv97vWsg1r9QcsuGzMxw36km
         aiE+xxnuBuCzRq6ZySlgRbukTAIotR3rPzuxK9sYDhdOtbJOYhQWf0LNhcaG8CyaZDaH
         h1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yRkJJfDJ1hFPMppUtn11BxgK0MvTcayru+8IH/S3SHM=;
        b=uZxcINos6dVhAROyKmKi9di65iv1cTgvVaJEl72SmlfCbRFCmdsDpXOTpQwpgqVQ1B
         G29AKPCJaHKUPUlGdzsJI+wQXEJp/wPa0IJMu2gx5JCruB73cJPlvSyZ33OrbtaHBFnj
         IlBD8a2akPzxLlfOmwWUMZ+26FkeANkxlXDixeTLIuT/tfs9a+ZKXS+bBEiikngDR+Z0
         ng+qQXSQ5JXfvxi1rTb4lSWCgouz+QPXXEQVvZ/iUyhxDjOyF+amw5oeX3srzbGRobWA
         aACnhdq6iHlCOfCFXDo20LRva7O6gcAbKqoW3+8IMWJXQIxGdCWYWoyUJIkLYXF8Ob6c
         6XpA==
X-Gm-Message-State: APjAAAWOF1DC0MiwlL6RMBvkB/kbDsvW++UupluPAGRtVZOdeYrDhPeN
        Dncc6U5jbJZ3wB5fdicoPhE=
X-Google-Smtp-Source: APXvYqz4LduHpfDAl0/RniAliG3DSPQw2qr2Yof0uPrOf4k3o8TK7Zmjjeg2+m8eqUpMaEVtEaFzlA==
X-Received: by 2002:aa7:9ab6:: with SMTP id x22mr46264373pfi.260.1582462631523;
        Sun, 23 Feb 2020 04:57:11 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id t11sm8797856pgi.15.2020.02.23.04.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 04:57:10 -0800 (PST)
Date:   Sun, 23 Feb 2020 20:56:49 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: add perf to the list of test directories
Message-ID: <20200223125135.GC3840@desktop>
References: <20200218142945.3719579-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218142945.3719579-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 18, 2020 at 09:29:45AM -0500, Josef Bacik wrote:
> I noticed that despite having PERF_CONFIGNAME set I wasn't getting the
> perf/ tests run when I used -g auto.  This is because it's not included
> in the list of directories to look at.  Fix this so that perf tests get
> run as well.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

I don't think the perf test infra is widely used by developers and
testers yet, so adding perf tests to default 'auto' tests would bring
unexpected failures.

So I think it's better to keep it not run by default for now, and if you
want to run perf tests in your test env, you could do it easily by
adding "-g perf/auto" option to "./check", e.g.

	./check -g auto -g perf/auto

And if there're frequent users of the perf infra, please reply this
thread and let us know, it'd be interesting to know how many users are
there.

Thanks,
Eryu

> ---
>  check | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check b/check
> index 89f3358a..9e7b6134 100755
> --- a/check
> +++ b/check
> @@ -44,7 +44,7 @@ timestamp=${TIMESTAMP:=false}
>  
>  rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.xlist $tmp.report.*
>  
> -SRC_GROUPS="generic shared"
> +SRC_GROUPS="generic shared perf"
>  export SRC_DIR="tests"
>  
>  usage()
> -- 
> 2.24.1
> 
