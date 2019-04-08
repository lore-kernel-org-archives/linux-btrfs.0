Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7BEC10F14
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A31A2087F
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfDHQiv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:38:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:58278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfDHQiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 12:38:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE1F9AD9D;
        Mon,  8 Apr 2019 16:38:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 40E36DA88B; Mon,  8 Apr 2019 18:39:57 +0200 (CEST)
Date:   Mon, 8 Apr 2019 18:39:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Radostin Stoyanov <rstoyanov1@gmail.com>
Cc:     viro@zeniv.linux.org.uk, luisbg@kernel.org, clm@fb.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [PATCH] fs: remove trailing whitespace
Message-ID: <20190408163957.GZ29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Radostin Stoyanov <rstoyanov1@gmail.com>,
        viro@zeniv.linux.org.uk, luisbg@kernel.org, clm@fb.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-aio@kvack.org
References: <20190406000723.31111-1-rstoyanov1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406000723.31111-1-rstoyanov1@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 01:07:23AM +0100, Radostin Stoyanov wrote:
> $ cd fs/
> $ find . -type f -exec sed --in-place 's/[[:space:]]\+$//' {} \+
> 
> Signed-off-by: Radostin Stoyanov <rstoyanov1@gmail.com>
> ---
>  fs/btrfs/qgroup.c                      |   2 +-
>  fs/btrfs/transaction.c                 |   2 +-
>  fs/btrfs/tree-log.c                    |   2 +-

No whitespace-only patches in btrfs please. New patches with trailing
whitespace suffer some serious eyebrows frowning, but we can live what's
in the tree and clean it eventually with along other changes.
