Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4B0C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB01619B2
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Mar 2021 16:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhCWQJi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:09:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:57570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhCWQJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Mar 2021 12:09:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63BCFADF1;
        Tue, 23 Mar 2021 16:09:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7222FDA7AE; Tue, 23 Mar 2021 17:07:07 +0100 (CET)
Date:   Tue, 23 Mar 2021 17:07:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     pierre.labastie@neuf.fr
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: build system - do not use AC_DEFINE
 twice
Message-ID: <20210323160707.GI7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, pierre.labastie@neuf.fr,
        linux-btrfs@vger.kernel.org
References: <20210320092728.24673-1-pierre.labastie@neuf.fr>
 <20210320092728.24673-2-pierre.labastie@neuf.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320092728.24673-2-pierre.labastie@neuf.fr>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 20, 2021 at 10:27:28AM +0100, pierre.labastie@neuf.fr wrote:
> From: Pierre Labastie <pierre.labastie@neuf.fr>
> 
> Autoheader uses the AC_DEFINE macros (and a few others) to populate
> the config.h.in file. The autotools documentation does not tell
> what happens if AC_DEFINE is used twice for the same identifier.
> 
> This patch prevents using AC_DEFINE twice for
> HAVE_OWN_FIEMAP_EXTENT_DEFINE, preserving the logic (using the
> fact that an undefined identifier in a preprocessor directive is
> taken as zero).
> 
> Signed-off-by: Pierre Labastie <pierre.labastie@neuf.fr>

Added to devel, thanks.
