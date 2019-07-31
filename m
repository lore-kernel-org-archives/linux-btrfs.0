Return-Path: <SRS0=LXly=V4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EA4C433FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Jul 2019 17:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FEB52067D
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Jul 2019 17:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfGaRim (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 13:38:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:49676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727276AbfGaRim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jul 2019 13:38:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC7C0ABF4;
        Wed, 31 Jul 2019 17:38:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 598E6DA7ED; Wed, 31 Jul 2019 19:39:15 +0200 (CEST)
Date:   Wed, 31 Jul 2019 19:39:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Btrfs: fixes for inode cache (-o inode_cache)
Message-ID: <20190731173915.GQ28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190704152400.20614-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704152400.20614-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 04, 2019 at 04:24:00PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Just a small set of fixes for the inode cache feature, mostly hangs due to
> missing wakeups or incomplete error handling, as well as an inode block
> reserve leak when hitting ENOSPC.

Thanks for the fixes, all added to misc-next. The feature is rarely used
and the manual page discrourages that too, only in a very special case.
I personally would like to deprecate it and delete completely, for
several reasons, so I suggest you don't spend too much time on it.
