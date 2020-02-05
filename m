Return-Path: <SRS0=o+mG=3Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E481C35247
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 15:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC1A220730
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 15:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgBEPoe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 10:44:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:38808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgBEPoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Feb 2020 10:44:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48FD0ACB9;
        Wed,  5 Feb 2020 15:44:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4FEA1DA7E6; Wed,  5 Feb 2020 16:44:19 +0100 (CET)
Date:   Wed, 5 Feb 2020 16:44:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH 44/44] btrfs: rename btrfs_put_fs_root and
 btrfs_grab_fs_root
Message-ID: <20200205154417.GT2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
References: <20200124143301.2186319-1-josef@toxicpanda.com>
 <20200124143301.2186319-45-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124143301.2186319-45-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 24, 2020 at 09:33:01AM -0500, Josef Bacik wrote:
> We are now using these for all roots, rename them to btrfs_put_root()
> and btrfs_grab_root();

Regarding the naming, the usual pattern is get/put, while grab does not
necessarily have to pair with anything and is for special cases (like
igrab). btrfs_get_root is free so we can use it.
