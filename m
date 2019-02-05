Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D119C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C3E2175B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfBETHV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:07:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:45302 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbfBETHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 14:07:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B115ABF5;
        Tue,  5 Feb 2019 19:07:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32E88DA7E3; Tue,  5 Feb 2019 20:06:39 +0100 (CET)
Date:   Tue, 5 Feb 2019 20:06:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] btrfs: change set_level() to bound the level
 passed in
Message-ID: <20190205190636.GZ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190204202008.51652-10-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204202008.51652-10-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 04, 2019 at 03:20:05PM -0500, Dennis Zhou wrote:
> -unsigned int btrfs_compress_str2level(const char *str)
> +unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
>  {
> -	if (strncmp(str, "zlib", 4) != 0)
> +	unsigned int level;
> +	int ret;
> +
> +	if (!type)
>  		return 0;
>  
> -	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
> -	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
> -		return str[5] - '0';
> +	if (str[0] == ':') {
> +		ret = kstrtouint(str + 1, 10, &level);

The docs kstrtouint of say that initial + is also accepted, I'd rather
keep the level specification strict, ie. no "zlib:+3" and no garbage
after the number.

The validation is currently missing but I think we should catch levels
out of range during mount/remount. The fallback to default is a safety
but wrong specification should be communicated to the user early.
