Return-Path: <SRS0=PX3t=BX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7B1C433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 13:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C031820855
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 13:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHMN4l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 09:56:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:43540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgHMN4l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Aug 2020 09:56:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88F8EB19E;
        Thu, 13 Aug 2020 13:57:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D561DA6EF; Thu, 13 Aug 2020 15:55:37 +0200 (CEST)
Date:   Thu, 13 Aug 2020 15:55:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove fsid argument from
 btrfs_sysfs_update_sprout_fsid
Message-ID: <20200813135537.GG2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200812131851.9129-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812131851.9129-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 12, 2020 at 04:18:51PM +0300, Nikolay Borisov wrote:
> It can be accessed from 'fs_devices' as it's identical to
> fs_info->fs_devices. Also add a comment about why we are calling the
> function. No semantic changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
