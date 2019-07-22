Return-Path: <SRS0=nkuV=VT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2173CC76188
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jul 2019 12:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0AA5218A0
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jul 2019 12:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfGVMoY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:44:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:56744 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727510AbfGVMoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jul 2019 08:44:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02644AE60;
        Mon, 22 Jul 2019 12:44:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3BAADA882; Mon, 22 Jul 2019 14:44:57 +0200 (CEST)
Date:   Mon, 22 Jul 2019 14:44:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix a printf format string fatal warning
Message-ID: <20190722124457.GO20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190713231454.45129-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713231454.45129-1-kilobyte@angband.pl>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jul 14, 2019 at 01:14:54AM +0200, Adam Borowski wrote:
> At least in Debian, default build flags include -Werror=format-security,
> for good reasons in most cases.  Here, the string comes from strftime --
> and though I don't suspect any locale would be crazy enough to have %X
> include a '%' char, the compiler has no way to know that.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Applied, thanks.
