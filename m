Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A0BC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 20:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB892083B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549396805;
	bh=Wdd1no7rVGuM+7VlGsuAdbMgNO8MPozvrNqsVcfDDR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d0l8V96BjNp3llmzTtJ+rUPojmw2KQRkTKsCDfGUxmSUWkx8IhVsmUUrE7cSEFGg/
	 6eB7fg2tKY+BLNzYlvMKRNwplMN40kTsEo88foGl22/4PbeE51NnKr4Yy5s0ZKoFO2
	 xF1PYDuIWZ5UmICzhno3nwtattiQArtoaXx15IvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfBEUAA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:00:00 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36855 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfBEUAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 15:00:00 -0500
Received: by mail-yw1-f67.google.com with SMTP id 189so1175650ywi.3;
        Tue, 05 Feb 2019 11:59:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Se/+8eaxu2zkftTiRN5RT1t4udCrHLbEvlZo3zodOJk=;
        b=FlRfHHzy2k215NbHY7mU0Vbxhu8HBCGYLNDS5Coz16YkvGchklL1DCrVKk3bnFgR7L
         3B29ELGR03hua1yALWyCIWt9kJ/AW3CYX2myLs/9Lntm3uCWdGATqaoCxvk9CQ+Ornac
         MRw7w9835juuJfxHtR8dKn8i9W8+aT7PitpFG1CAu7VFzmLMB5f9tSRhk9zIwr/jPd5r
         zIevGhpcYrFZ8QBqMzOjjkqAaBWNEyNOyWMaSWQaMM9Cb3Btz/uX/RofaW5BFY/7RMCh
         iGaCblBS6EPDzHdBCWm04XMW3tHF4JqZ0s8ZUbdlIWu7mqwPNSYAabm3S5Vuge2xZv/r
         TQnQ==
X-Gm-Message-State: AHQUAuYlRqLuNbiGpagmDdZid7Za8iT1fknrx/SgziHakVUspKEKJpuB
        CRBEKEg/SjcQ71PF40+CcBU=
X-Google-Smtp-Source: AHgI3IaipDzbdP+SGQqiqKroWuviTkHDbL3xOkNE+ZbKTs31PloZw/+zjbqxPBlgfHRMktZlTvzVfA==
X-Received: by 2002:a81:30d6:: with SMTP id w205mr5577355yww.27.1549396798986;
        Tue, 05 Feb 2019 11:59:58 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id 66sm1493668ywd.33.2019.02.05.11.59.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 11:59:57 -0800 (PST)
Date:   Tue, 5 Feb 2019 14:59:55 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] btrfs: change set_level() to bound the level
 passed in
Message-ID: <20190205195955.GA28437@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190204202008.51652-10-dennis@kernel.org>
 <20190205190636.GZ2900@twin.jikos.cz>
 <20190205193254.GB24701@dennisz-mbp.dhcp.thefacebook.com>
 <20190205195414.GA2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205195414.GA2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 08:54:15PM +0100, David Sterba wrote:
> On Tue, Feb 05, 2019 at 02:32:54PM -0500, Dennis Zhou wrote:
> > On Tue, Feb 05, 2019 at 08:06:37PM +0100, David Sterba wrote:
> > > On Mon, Feb 04, 2019 at 03:20:05PM -0500, Dennis Zhou wrote:
> > > > -unsigned int btrfs_compress_str2level(const char *str)
> > > > +unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
> > > >  {
> > > > -	if (strncmp(str, "zlib", 4) != 0)
> > > > +	unsigned int level;
> > > > +	int ret;
> > > > +
> > > > +	if (!type)
> > > >  		return 0;
> > > >  
> > > > -	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
> > > > -	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
> > > > -		return str[5] - '0';
> > > > +	if (str[0] == ':') {
> > > > +		ret = kstrtouint(str + 1, 10, &level);
> > > 
> > > The docs kstrtouint of say that initial + is also accepted, I'd rather
> > > keep the level specification strict, ie. no "zlib:+3" and no garbage
> > > after the number.
> > > 
> > > The validation is currently missing but I think we should catch levels
> > > out of range during mount/remount. The fallback to default is a safety
> > > but wrong specification should be communicated to the user early.
> > 
> > Ok. To make sure I understand properly for improper level (ie "30",
> > "+3", "+3d") set the level to default (already done) and pr_warn saying
> > invalid level?
> 
> So we have (at least) two ways how to handle:
> 
> - warn and fail the mount -- catch typos and the like, continuing with
>   default could cause problems later though not that severe as the
>   compressionw would be different than expected, but this could be
>   considered a usability bug
> 
> - only warn and continue with the default -- not mounting a root
>   filesystem just because of a typo can be worse than mounting with
>   wrong level; as long as there's a warning in the log, the user still
>   has a working system and can fix it manually
> 
> Both have some pros and cons and initially I was more inclined to pick
> the 1st option, but now that I'm thinking about that again, the other
> has some merit.
> 
> Given that zlib now falls back to default for unrecognized level, we
> should probably stick to that for zstd too.

Ok. With that I'll run a v3 adding a warning for a '+' or invalid input.

I think moving compression to being a property rather than a mount
option would be ideal. That would enable multiple compression levels per
mount and prevent remounting with incorrect mount options.

Thanks,
Dennis
