Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60218C282CC
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3D8207E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549384222;
	bh=NXJpHAIdRxGU9vi3l4qUn/H7R4BlApj6s9uTgbGxUA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YDCmjfQ7dxulHJ2ZRHUl5X0z5sXLbOs41kOHv2uuLYPHgJxOtwvVI/NlLAka3G6EE
	 c5uD4mNPQutYXt2Y60BF5SeZtgD6iXB0xOC/tcdUS9m9nRbHqZeBCqhhgfGGBcgz83
	 VrnzqyjqZ7Bie/Dswe4ONAjpjMyOMlcmfMU1lpA0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfBEQaR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:30:17 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39695 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbfBEQaQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 11:30:16 -0500
Received: by mail-yb1-f195.google.com with SMTP id s17so1234987ybp.6;
        Tue, 05 Feb 2019 08:30:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=87oq8zs2wfjwiJn75iXKc6IgY09laMqNYQiVSsqYps8=;
        b=F96Bisd0jOAp7D4IcpOGiIhYkm3il/z3LgFjFaI2/PYeJozl6zi+rCIcygPtsYLoV7
         4Bm/BwbHs7HoFHvPPRLXX4VJZEKWdPjPK7GWAkYHeC7T4jsvgmUMYfAHBh6Mi/laro53
         jk/nw65wyUz0lhfRbXqJIuF8F8iJsHMZ+se65nQO2x4CG7xCkXb7ydP3mCS/yfDy/ZFK
         Opbk0KeQp7sSv6rHCOkP34CNjicI8VwQ2JpDyNDfWEfa6LB+tvuPAxmku71FTJKYER4f
         StpA/2vyM0arntogQtZNg2sFoUlIbJ96+lD14H8AR8Ke5fFKFVZta3W11YQ85SPrFndw
         Fsxw==
X-Gm-Message-State: AHQUAuY3cthEiXjZSRfYcktx37YAuoLS7dM+yS7bNFyn4uAXhDqMimOx
        sZfb3wk+aDhq+MjEUrqSbh0=
X-Google-Smtp-Source: AHgI3Ib2PpZziu1raGFKbgp7kAPbl4aBV/Hqdw/IZc6M0BpIf8d5KHFu6FXdPQf7LZmFDhyxRz7ygA==
X-Received: by 2002:a25:a367:: with SMTP id d94mr4811529ybi.400.1549384215672;
        Tue, 05 Feb 2019 08:30:15 -0800 (PST)
Received: from dennisz-mbp ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id l74sm1836327ywl.99.2019.02.05.08.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 08:30:14 -0800 (PST)
Date:   Tue, 5 Feb 2019 11:30:12 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190205163012.GB89375@dennisz-mbp>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190205145753.GR2900@twin.jikos.cz>
 <20190205160302.GA89375@dennisz-mbp>
 <20190205162733.GT2900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205162733.GT2900@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 05:27:34PM +0100, David Sterba wrote:
> On Tue, Feb 05, 2019 at 11:03:02AM -0500, Dennis Zhou wrote:
> > On Tue, Feb 05, 2019 at 03:57:53PM +0100, David Sterba wrote:
> > > On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> > > > Hi everyone,
> > > > 
> > > > V2 had only a handful of changes outside of minor feedback.
> > > > 0001:
> > > > - use functions over macros
> > > > 0003:
> > > > - BTRFS_NR_WORKSPACE_MANAGERS is added instead of overriding
> > > >   BTRFS_COMPRESS_TYPES
> > > > 0011 (new):
> > > > - address monotonic memory requirement for zstd workspaces
> > > > 0012:
> > > > - increase reclaim timer to 307s from 67s
> > > > - move from keeping track of time in ns to jiffies
> > > > - remove timer in cleanup code
> > > > - use min_t() instead of if statements in .set_level()
> > > > - add header text to describe how workspaces are managed
> > > > - nofs_flag type -> unsigned long to unsigned int
> > > 
> > > Something is wrong, the patchset on top of 5.0-rc5 hangs in test
> > > btrfs/007, without a stacktrace. V1 was fine and I double checked that
> > > rc5 itself is fine.
> > 
> > Hmmm, well that's awkward. I ran xfstests and that test passed on my
> > machine. I'll figure out the delta and submit a v3. Thanks David!
> 
> It failed on a VM and 2 other physical machines, so it's not somethig
> related to the testing setup.

Oh, I wasn't alluding to that. I'm more that sure it's my fault
somewhere along the line.

Thanks,
Dennis
