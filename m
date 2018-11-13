Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FE4C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 12:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278F02243E
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 12:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278F02243E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbeKMWcQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 17:32:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:51794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732884AbeKMWcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 17:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 62404B045;
        Tue, 13 Nov 2018 12:34:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8BD5DDAC47; Tue, 13 Nov 2018 13:34:02 +0100 (CET)
Date:   Tue, 13 Nov 2018 13:34:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] bitops: Fix big endian compilation
Message-ID: <20181113123402.GW24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Rosen Penev <rosenp@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20181105190643.13578-1-rosenp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105190643.13578-1-rosenp@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 05, 2018 at 11:06:41AM -0800, Rosen Penev wrote:
> Replaced bswap with _ variants. While it's a glibc extension, all of the
> popular libc implementations (glibc, uClibc, musl, BIONIC) seem to support
> it.
> 
> Added static inline to two functions to match little endian variants. This
> fixes a linking error experienced when compiling.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

1-3 applied, thanks.
