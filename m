Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5465C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 15:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2492087F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 15:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfA1PE5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:04:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:59560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbfA1PE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:04:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC612AE04;
        Mon, 28 Jan 2019 15:04:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 238F8DA78C; Mon, 28 Jan 2019 16:04:20 +0100 (CET)
Date:   Mon, 28 Jan 2019 16:04:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] btrfs: oops in device_list_add()
Message-ID: <20190128150420.GG2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Al Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190127045755.GH2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190127045755.GH2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jan 27, 2019 at 04:58:00AM +0000, Al Viro wrote:
> 	alloc_fs_devices() can return ERR_PTR(-ENOMEM), so
> dereferencing its result before the check for IS_ERR() is
> a bad idea...
> 
> Fixes: d1a63002829a4
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks, added to 5.0-rc queue.
