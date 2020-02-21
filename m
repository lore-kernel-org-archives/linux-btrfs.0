Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274F4C35656
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 055E824650
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBUQsw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:48:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:53092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgBUQsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 11:48:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4DCDCAF8E;
        Fri, 21 Feb 2020 16:48:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74E82DA70E; Fri, 21 Feb 2020 17:48:32 +0100 (CET)
Date:   Fri, 21 Feb 2020 17:48:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Minor UUID cleanup
Message-ID: <20200221164831.GM2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200218145609.13427-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218145609.13427-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:56:06PM +0200, Nikolay Borisov wrote:
> Here is a short series that removes one indirect call in btrfs_uuid_tree_iterate
> and making uuid rescan functions private to disk-io.c since they are used only
> during mount. 
> 
> Nikolay Borisov (3):
>   btrfs: Call btrfs_check_uuid_tree_entry directly in
>     btrfs_uuid_tree_iterate
>   btrfs: export btrfs_uuid_scan_kthread
>   btrfs: Make btrfs_check_uuid_tree private to disk-io.c

With the fixups applied, added to misc-next. Thanks.
