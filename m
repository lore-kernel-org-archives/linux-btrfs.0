Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E38BC67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 21:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A163120651
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 21:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="uoyDhRHu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A163120651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbeJWFdl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:33:41 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40844 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbeJWFdl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 01:33:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id 1-v6so19637427plv.7
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 14:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ghSTCKdySFc2MGIGBECvzlCyAZnLoKKjAfpsBg0DY4=;
        b=uoyDhRHuvv/wlm8ovCa20UvSosufgDAdoqIx+QbHTryoTE3r/eU6nzz8X6ydnp6DxR
         HI9ULn8hfQunPuaW5KbP0xL9ErEGxB/Tp2gIkUIChu3Mq5WFFtPrfkvFLaqW1X2idLDV
         5EBCVg2pMnKEuv8bHZMTx3i/hkfkQMB+RlWCpH37mjRWaHm41azWyK09S7Ocd7dHwi4I
         l0FrVcP88jrBV95G5AcVZzcenzL4IHj3ZngJbWmbvll1cGNyJ5dSWjckEoGvcE5YfyJi
         R7HralIL1vWiW48cr3NeoC3icUplvHezOe4FAOaFFubeND9WgAb/0loNw+VnNgQR9bRe
         mVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ghSTCKdySFc2MGIGBECvzlCyAZnLoKKjAfpsBg0DY4=;
        b=JZOAq5XV+sPsxwLBoQQ168zT8bMpePOZjDV5kKZNQkfsIRyC7+OM8Q3VfwDvXNg9ws
         213bnPqLXAF98TEp0/j7o6xxXtRP4PaIY4597z+5k8bBx4YkiulxnDCi8TuOi8687ti1
         gT4yHiMEXML1o26KGoV3fx0U0ru+vvX/6cbhjhPsD/r9Xz4Y4jogeRXTbxROucmnSn7O
         dqETSO3YfZrpQ6WGGPh651v05sTdmrqykhDqMf5drYM7shYRN0LJIZyvq8QSFbOrwo1L
         h37RN9k7VbkSnvapgcm49gcy7I3g6lJVPxWnpf8/yrMjXX+R2i/KVhMupko5PxE0tpYR
         VShQ==
X-Gm-Message-State: AGRZ1gJd/zCT9RWwSuqdcak0lijmXLCEdBc8uGs9ZUWIvw2eyzfCkQ+/
        Kv1SwNW1/xEEEgF9TkFTG+CuUg==
X-Google-Smtp-Source: AJdET5cnS2dMAz0tSMjVY1fOZs8AXaXAtf9PhpwQY23pIzEGuNZYVRWphPpw2L82hK/XkTciNEHyjw==
X-Received: by 2002:a17:902:904a:: with SMTP id w10-v6mr7560803plz.225.1540242809133;
        Mon, 22 Oct 2018 14:13:29 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::5:b6e0])
        by smtp.gmail.com with ESMTPSA id b10-v6sm48427767pfe.148.2018.10.22.14.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 14:13:28 -0700 (PDT)
Date:   Mon, 22 Oct 2018 14:13:27 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181022211327.GA10074@vader>
References: <cover.1538072009.git.osandov@fb.com>
 <20181019154318.GK16290@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181019154318.GK16290@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 19, 2018 at 05:43:18PM +0200, David Sterba wrote:
> On Thu, Sep 27, 2018 at 11:17:32AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > This series implements swap file support for Btrfs.
> > 
> > Changes from v8 [1]:
> > 
> > - Fixed a bug in btrfs_swap_activate() which would cause us to miss some
> >   file extents if they were merged into one extent map entry.
> > - Fixed build for !CONFIG_SWAP.
> > - Changed all error messages to KERN_WARN.
> > - Unindented long error messages.
> > 
> > I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
> > ack for that one, too.
> > 
> > Thanks!
> > 
> > 1: https://www.spinics.net/lists/linux-btrfs/msg82267.html
> > 
> > Omar Sandoval (6):
> >   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
> >   mm: export add_swap_extent()
> >   vfs: update swap_{,de}activate documentation
> >   Btrfs: prevent ioctls from interfering with a swap file
> >   Btrfs: rename get_chunk_map() and make it non-static
> >   Btrfs: support swap files
> 
> Patches 1 and 2 now going through Andrew's tree, the btrfs part will be
> delayed and not merged to 4.20. This is a bit unfortuante, I was busy
> with the non-feature patches and other things, sorry.

That's perfectly fine with me, thanks, Dave!
