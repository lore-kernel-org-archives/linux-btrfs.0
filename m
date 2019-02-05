Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A785C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 097042080F
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549382594;
	bh=4YgDT/R/ba7h7XQq7DZOmfSNJkFK8hdNVzZby8Ene+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=I+bu6jhSdkmD85W4+c578mltSVoRo0k5wMmgo8Unkm1tXaUQzX87u09GzYf1BYuIc
	 6ClrQdeaavvBNhwbS/a3Lepcy7IEtGnhLZ9Nj/FoTHSZu0tjhtCMgUHJ2dcPr4iR+N
	 BufMuEvNLk4pYY5UwIKy3lySKH9tfm97vusixEMc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfBEQDI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:03:08 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46417 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbfBEQDI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 11:03:08 -0500
Received: by mail-yb1-f194.google.com with SMTP id 7so1194753ybp.13;
        Tue, 05 Feb 2019 08:03:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KuI/qIMQ/ifYS4g015UrnUEfysQwSyKLYSwzEuhRjFY=;
        b=L7AUQfScjde8g8vYAG5crJyipDzCVorb3emYeykMevF/evva5tyEUmLFkUpS1wVsiZ
         5j6qdvzGK8P/b6BJEtr1wenqPl0vXNA7zpFfsY+KLxjdsHLsF0vlKznpfJnTjxPFW0in
         wYmwT8jo52k1OYlRk4GrZihvx+ncta2+bo8DLRFkVHpyKATh7/N0T73a5wPEqFmC9wo9
         dbrPcseGLd6cNVqG0T4GxMxr6lwQvMPf8Tk2dDpZThCmmr7c4wiljdEEFvzSchbvWQC3
         ib/Ladtza59MMKXk0lS0WZmVAhR1ABLMzQAIKV8xUCaejItyDB7W/vRDwXD4ii8dqupF
         5I7w==
X-Gm-Message-State: AHQUAua6WtC2loZ7uYNwwOZUIJoumVFnPO5M2YZklMEIRf46vugszQAF
        pDiqIhAUHBS/jLZQXLrQWQ0=
X-Google-Smtp-Source: AHgI3IaDSbWl2bOMW+F4/Vg/PjikAANlOEXSDfi3E4WP3ppw5wIjS/VDy/8JNLEpptJzE75dTX0c6Q==
X-Received: by 2002:a25:4d84:: with SMTP id a126mr4436460ybb.33.1549382586822;
        Tue, 05 Feb 2019 08:03:06 -0800 (PST)
Received: from dennisz-mbp ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id x9sm1288679ywc.8.2019.02.05.08.03.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 08:03:05 -0800 (PST)
Date:   Tue, 5 Feb 2019 11:03:02 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190205160302.GA89375@dennisz-mbp>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190205145753.GR2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205145753.GR2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 03:57:53PM +0100, David Sterba wrote:
> On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> > Hi everyone,
> > 
> > V2 had only a handful of changes outside of minor feedback.
> > 0001:
> > - use functions over macros
> > 0003:
> > - BTRFS_NR_WORKSPACE_MANAGERS is added instead of overriding
> >   BTRFS_COMPRESS_TYPES
> > 0011 (new):
> > - address monotonic memory requirement for zstd workspaces
> > 0012:
> > - increase reclaim timer to 307s from 67s
> > - move from keeping track of time in ns to jiffies
> > - remove timer in cleanup code
> > - use min_t() instead of if statements in .set_level()
> > - add header text to describe how workspaces are managed
> > - nofs_flag type -> unsigned long to unsigned int
> 
> Something is wrong, the patchset on top of 5.0-rc5 hangs in test
> btrfs/007, without a stacktrace. V1 was fine and I double checked that
> rc5 itself is fine.

Hmmm, well that's awkward. I ran xfstests and that test passed on my
machine. I'll figure out the delta and submit a v3. Thanks David!

Thanks,
Dennis
