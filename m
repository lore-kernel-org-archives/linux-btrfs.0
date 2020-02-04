Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4F5C35247
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 23:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FBD321582
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 23:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgBDXs2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 18:48:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:58470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgBDXs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Feb 2020 18:48:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9DF1AD69;
        Tue,  4 Feb 2020 23:48:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D7DDDA80D; Wed,  5 Feb 2020 00:48:14 +0100 (CET)
Date:   Wed, 5 Feb 2020 00:48:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/44][v5] Cleanup how we handle root refs, part 1
Message-ID: <20200204234813.GI2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20200124143301.2186319-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124143301.2186319-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 24, 2020 at 09:32:17AM -0500, Josef Bacik wrote:
> v4->v5:
> - split out the btrfs_free_fs_info() moving around into it's own patch.
> - updated a comment in btrfs_get_root() to describe why we are initializing part
>   of the fs_info

Patches 1-9 are preparatory and don't change the root ref logic so I'll
add them to misc-next now, the rest will follow.
