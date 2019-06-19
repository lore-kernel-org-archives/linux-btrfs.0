Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E24EC43613
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 22:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C8AF215EA
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 22:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFSWaA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:30:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:33258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbfFSWaA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 18:30:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 274A1AC8C
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 22:29:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B7F42DA897; Thu, 20 Jun 2019 00:30:46 +0200 (CEST)
Date:   Thu, 20 Jun 2019 00:30:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Remove old send implementation
Message-ID: <20190619223046.GI8917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190619140440.5550-1-nborisov@suse.com>
 <20190619140440.5550-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619140440.5550-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 19, 2019 at 05:04:39PM +0300, Nikolay Borisov wrote:
> Commit ba23855cdc89 ("btrfs-progs: send: use splice syscall instead of
> read/write to transfer buffer") changed the send implementation to use
> splice(). The old read/write implementation hasn't be used for at least
> 3 years, it's time to remove it.

I left it there in case there are problems with splice so we could
potentially offer option for the copy mechanism, but time proved it's
not necessary.
