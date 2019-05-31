Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE89C04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 20:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AB226EC9
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 20:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfEaULn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 16:11:43 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:43038 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727316AbfEaULn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 16:11:43 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 16:11:42 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 3DF3D1804EE34
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2019 20:05:46 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 94FE640D7;
        Fri, 31 May 2019 20:05:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: milk45_14de4368b0321
X-Filterd-Recvd-Size: 2042
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 May 2019 20:05:43 +0000 (UTC)
Message-ID: <a7a2a7c70c2dcef122ddbe86eb84820fc4384c7e.camel@perches.com>
Subject: Re: [PATCH] btrfs: Fix -Wunused-but-set-variable warnings
From:   Joe Perches <joe@perches.com>
To:     Andrey Abramov <st5pub@yandex.ru>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 May 2019 13:05:41 -0700
In-Reply-To: <20190531195349.31129-1-st5pub@yandex.ru>
References: <20190531195349.31129-1-st5pub@yandex.ru>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-05-31 at 22:53 +0300, Andrey Abramov wrote:
> Fix -Wunused-but-set-variable warnings in raid56.c and sysfs.c files

trivia:

> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index f3d0576dd327..4ab29eacfdf3 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1182,22 +1182,17 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
>  	int nr_data = rbio->nr_data;
>  	int stripe;
>  	int pagenr;
> -	int p_stripe = -1;
> -	int q_stripe = -1;
> +	int is_q_stripe = 0;

These uses seem boolean, so perhaps just use bool?

> +	if (rbio->real_stripes - rbio->nr_data == 2)
> +		is_q_stripe = 1;
[]
> @@ -1241,7 +1236,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
[]
> +		if (is_q_stripe) {
> @@ -2340,8 +2335,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
[]
> +	int is_q_stripe = 0;
> @@ -2351,14 +2345,10 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
> +	if (rbio->real_stripes - rbio->nr_data == 2)
> +		is_q_stripe = 1;
[]
> @@ -2380,7 +2370,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
[]
> +	if (is_q_stripe) {


