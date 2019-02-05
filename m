Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AB6C282CC
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD5E217D6
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549395184;
	bh=aCWyHLjpAoHQa+k0gdXta9KBbNnz4jOsif6iFLYmAvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pXDkaSqVTOtGdF/3+33cuQxbbnuspRamYpJg5ri0OY/FSWdOWeOJrfyD8aJMqQloi
	 4XyTWJ/ps2BuK3X7V/9qgNbl3daOKumsBnnNroUz4QcWZ98yEWFydrVWZreqW1U/IX
	 aiuxGcc0L1EZW3VEytCR+Km00de92pKc6dGGc/i8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfBETc6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:32:58 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43980 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfBETc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 14:32:58 -0500
Received: by mail-yb1-f195.google.com with SMTP id s76so1490972ybs.10;
        Tue, 05 Feb 2019 11:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dhH+1GJGi3DhxrRj1lIJWvFrmcYd/LP6aeKG5NQTj/Q=;
        b=I3r8IBGviKtuq+vVMwHO+Spdr6yF1XF1SsiNgzvYSM/pYlVjPRRQpzPkBwxaahp7HX
         mLQYAqeky5RVikfU/fuHq3j8YOkDOKqLWZcpOdt9X2WzJKVdByKgSTEyhiSPamEf27se
         pPlWTvAUycm+IfUDsUBdXpjvyc2aINkFI2U4WLWXznkzl15igcM9soAaDmmSKtoLei2j
         t0Jzc9+vA7n44uFUBb9IuYiai73p68JkAl3DE3vcGs9GccA60Ce1v1TPI2IxQIJMROAS
         SGm4VqXVOjv4yeJ9NFc2am9FJb85P0a1IkLeYBZNS8Ll4BlYqrb36l0jTtaikGNs8qve
         U1MA==
X-Gm-Message-State: AHQUAub6vC052dyidcaFz/yF72hYYsOoO1tdY2B6YJd0Hi7UsZo5567y
        gzbWhpe5hkle/wU52cgPYBQ=
X-Google-Smtp-Source: AHgI3IaUlHA5ErqidtZndACVvPyGr55dB4C06dP9GRtEDXDs0Tnkd/hZqmrUMYuq2IcyuyV/5nG3xw==
X-Received: by 2002:a25:6dd6:: with SMTP id i205mr5494436ybc.28.1549395177451;
        Tue, 05 Feb 2019 11:32:57 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id g84sm4225371ywg.9.2019.02.05.11.32.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 11:32:56 -0800 (PST)
Date:   Tue, 5 Feb 2019 14:32:54 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] btrfs: change set_level() to bound the level
 passed in
Message-ID: <20190205193254.GB24701@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190204202008.51652-10-dennis@kernel.org>
 <20190205190636.GZ2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205190636.GZ2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 08:06:37PM +0100, David Sterba wrote:
> On Mon, Feb 04, 2019 at 03:20:05PM -0500, Dennis Zhou wrote:
> > -unsigned int btrfs_compress_str2level(const char *str)
> > +unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
> >  {
> > -	if (strncmp(str, "zlib", 4) != 0)
> > +	unsigned int level;
> > +	int ret;
> > +
> > +	if (!type)
> >  		return 0;
> >  
> > -	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
> > -	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
> > -		return str[5] - '0';
> > +	if (str[0] == ':') {
> > +		ret = kstrtouint(str + 1, 10, &level);
> 
> The docs kstrtouint of say that initial + is also accepted, I'd rather
> keep the level specification strict, ie. no "zlib:+3" and no garbage
> after the number.
> 
> The validation is currently missing but I think we should catch levels
> out of range during mount/remount. The fallback to default is a safety
> but wrong specification should be communicated to the user early.

Ok. To make sure I understand properly for improper level (ie "30",
"+3", "+3d") set the level to default (already done) and pr_warn saying
invalid level?

Thanks,
Dennis
