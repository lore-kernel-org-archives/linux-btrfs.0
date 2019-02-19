Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA63C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F6A21736
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfBSPJ7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:09:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:44494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbfBSPJ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 10:09:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E69C1AFC7;
        Tue, 19 Feb 2019 15:09:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 09F39DA83C; Tue, 19 Feb 2019 16:11:19 +0100 (CET)
Date:   Tue, 19 Feb 2019 16:11:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     pkoroau pkoroau <pkoroau@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Spurious warning fix backport for 4.9
Message-ID: <20190219151116.GP9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, pkoroau pkoroau <pkoroau@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAMNwjELPWTLDFi=2Eyq0DZqW3Q+sqviz_R7CSp6cCV3QTJukPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMNwjELPWTLDFi=2Eyq0DZqW3Q+sqviz_R7CSp6cCV3QTJukPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 02:42:18PM +0000, pkoroau pkoroau wrote:
> Hi, I use Debian's default kernel 4.9. I booted 4.14 temporarily, installed
> system updates with compress=zlib:9, booted 4.9. Now, syslog is cluttered with
> hundreds of lines like:
> 
> BTRFS warning (device sda2): unhandled fiemap cache detected: offset=0
> phys=653004800 len=4096 flags=0x2000
> 
> The warning is apparently harmless, as noted at:
> https://www.spinics.net/lists/linux-btrfs/msg68326.html
> 
> The line of code issuing the warning was removed upstream at:
> https://patchwork.kernel.org/patch/9803291/
> 
> Is this the right place to ask for a backport to 4.9? As I understand the
> release process, Debian would pick it with the next stable kernel update.

Yes. I've checked our wiki if the process is described there, but it's
quite scattered and so I'm going to write it more clearly. The
mailinglist should work as a fallback in other cases.

I'll send the backport request myself in a minute so it'll appear in
stable soon. Thanks.
