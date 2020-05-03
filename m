Return-Path: <SRS0=kp3V=6R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2B3C28CBC
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 May 2020 21:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 580D2206B9
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 May 2020 21:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgECVpb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 May 2020 17:45:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:45900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbgECVpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 May 2020 17:45:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B6A8AE2B;
        Sun,  3 May 2020 21:45:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF662DA70B; Sun,  3 May 2020 23:44:42 +0200 (CEST)
Date:   Sun, 3 May 2020 23:44:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use crypto_shash_digest()
Message-ID: <20200503214442.GS18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        linux-btrfs@vger.kernel.org
References: <20200501065159.738746-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501065159.738746-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:51:59PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Use crypto_shash_digest() instead of crypto_shash_init() +
> crypto_shash_update() + crypto_shash_final().  This is more efficient.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Added to devel queue, thanks.
