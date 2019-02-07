Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20504C282C4
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40E821721
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549561025;
	bh=LsHh7f264VtIE54XseSwqZ4PI7lsN01WloF3xrRlp/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HVZOobRRh3xlMeORrCqNIVZ3kUG67B61hMIy2BZGxPN/w758LN3sfkrKoqo+mqY7e
	 9jW/OGj4jcb6IDUlITrBchjiw9aBuYTxfUvGs7jdg2+wwoxtb+HvQDcFYTt3pvoMmu
	 a/ypT6ZfRyD/6xmvtBFJBHQ8TikeyIQowlMGf+C4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfBGRhA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:37:00 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36693 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGRg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 12:36:59 -0500
Received: by mail-yw1-f67.google.com with SMTP id 189so280965ywi.3;
        Thu, 07 Feb 2019 09:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xIGj793GRzU67XK3Xz3Gpm1A+PlOBAW0CxTkOcYDMqM=;
        b=l/n15mi11mxRKx4U4ick0PWITAe6njscGz8UdUrftAKD8sqe/fwOE8zMu4A1PvoX+X
         rH9vPYT8oDn0eULYXht6XLvrTNnwuoIMGK8EzUQkuTNAKFA3viBPk0ykbNSnllwmDlx7
         pt/Jc6srg3rZZaJZn5lqPfUIhgQd6EvXZovEqCjVyFmTSRzMASE9VV9z6mP5MMsbvptU
         A1UyX6vj1+HBTz3qTY3GLdLYi1xHGn+OeXiLgUugCMp9tWXuA6J/MyKKiBIhe1bdibsb
         IM5xvM5DzV39W+phQHDr5JdCVoCeNcYO4k7bBpYDhQP4ZO49iIaZXKpHVUSo9Z0Ejnmx
         BudQ==
X-Gm-Message-State: AHQUAubB979s3MTqzd1pI27tr7ZTZdLPJwq3XMNFuhjrqQba4QrYCzpM
        ay6/+nShwLV0ldDP4AP8mA8=
X-Google-Smtp-Source: AHgI3IYvcLPtr/tbJCF+uCFn2dgEV6iS4uOpob19oblf7IaaqtxN0Gq+pfpbODdhUJmj508cIeiVUw==
X-Received: by 2002:a81:5f84:: with SMTP id t126mr14018296ywb.452.1549561018566;
        Thu, 07 Feb 2019 09:36:58 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::4:bab5])
        by smtp.gmail.com with ESMTPSA id w6sm2744464ywi.55.2019.02.07.09.36.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 09:36:57 -0800 (PST)
Date:   Thu, 7 Feb 2019 12:36:54 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190207173654.GA27942@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190207165925.GJ2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207165925.GJ2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 07, 2019 at 05:59:26PM +0100, David Sterba wrote:
> On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> > Dennis Zhou (12):
> >   btrfs: add helpers for compression type and level
> >   btrfs: rename workspaces_list to workspace_manager
> >   btrfs: manage heuristic workspace as index 0
> >   btrfs: unify compression ops with workspace_manager
> >   btrfs: add helper methods for workspace manager init and cleanup
> >   btrfs: add compression interface in (get/put)_workspace()
> >   btrfs: move to fn pointers for get/put workspaces
> >   btrfs: plumb level through the compression interface
> >   btrfs: change set_level() to bound the level passed in
> >   btrfs: zstd use the passed through level instead of default
> >   btrfs: make zstd memory requirements monotonic
> >   btrfs: add zstd compression level support
> 
> The patchset has been added to msic-next, scheduled for 5.1. I've left
> out the changes to warn on wrong level, so currently it falls back to
> the default. I don't want to make a last minute change of that sort, so
> this needs to go as a separate patch.

Regarding the bug report from Dan, do you want me to send you a patch
for it on top of the topic branch or do you mind fixing the missing:

unsigned int level = 0;

> 
> I also did a last pass through all patches and made some trivial changes
> like reformatting comments or minor style updates, nothing functional.
> The inter-branch diff can be found at
> https://github.com/kdave/btrfs-devel/compare/ext/dzhou/compr-workspaces-v2..kdave:ext/dzhou/compr-workspaces
> 
> The feature should be ready to use, though as mentioned before some fine
> tuning might be necessary to make the memory requirements more
> efficient. The code could be simplified or cleaned up now that there are
> 3 compressors, at this point stabilization fixes are preferred.
> 
> Thanks.

Thanks David!
Dennis
