Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870FBC169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F3E02175B
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfBFPv3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:51:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:55520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727870AbfBFPv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 10:51:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3DCCB6DC;
        Wed,  6 Feb 2019 15:51:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11A11DA823; Wed,  6 Feb 2019 16:50:50 +0100 (CET)
Date:   Wed, 6 Feb 2019 16:50:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: Wire btrfs support in get_free_sectors
Message-ID: <20190206155050.GE2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190206153359.2562-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206153359.2562-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 06, 2019 at 05:33:59PM +0200, Nikolay Borisov wrote:
>  [ "$FSTYP" = "xfs" ] && MKFS_OPTIONS="-f $MKFS_OPTIONS"
> +[ "$FSTYP" = "btrfs" ] && MKFS_OPTIONS="-f -dsingle -msingle"

This would drop anything that the original MKFS_OPTIONS had, eg. -O
features or -K, that's an example what I use.
