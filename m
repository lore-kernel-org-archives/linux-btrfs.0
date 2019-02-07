Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A36C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B520221872
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfBGRAF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:00:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:41522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbfBGRAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 12:00:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C500DB15C;
        Thu,  7 Feb 2019 17:00:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 458ACDA83D; Thu,  7 Feb 2019 17:59:26 +0100 (CET)
Date:   Thu, 7 Feb 2019 17:59:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190207165925.GJ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190204202008.51652-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> Dennis Zhou (12):
>   btrfs: add helpers for compression type and level
>   btrfs: rename workspaces_list to workspace_manager
>   btrfs: manage heuristic workspace as index 0
>   btrfs: unify compression ops with workspace_manager
>   btrfs: add helper methods for workspace manager init and cleanup
>   btrfs: add compression interface in (get/put)_workspace()
>   btrfs: move to fn pointers for get/put workspaces
>   btrfs: plumb level through the compression interface
>   btrfs: change set_level() to bound the level passed in
>   btrfs: zstd use the passed through level instead of default
>   btrfs: make zstd memory requirements monotonic
>   btrfs: add zstd compression level support

The patchset has been added to msic-next, scheduled for 5.1. I've left
out the changes to warn on wrong level, so currently it falls back to
the default. I don't want to make a last minute change of that sort, so
this needs to go as a separate patch.

I also did a last pass through all patches and made some trivial changes
like reformatting comments or minor style updates, nothing functional.
The inter-branch diff can be found at
https://github.com/kdave/btrfs-devel/compare/ext/dzhou/compr-workspaces-v2..kdave:ext/dzhou/compr-workspaces

The feature should be ready to use, though as mentioned before some fine
tuning might be necessary to make the memory requirements more
efficient. The code could be simplified or cleaned up now that there are
3 compressors, at this point stabilization fixes are preferred.

Thanks.
