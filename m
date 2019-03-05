Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5325FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CA0206DD
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfCEN3F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:29:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:47942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbfCEN3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 08:29:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 650D4AF9A;
        Tue,  5 Mar 2019 13:29:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CD411DA851; Tue,  5 Mar 2019 14:30:22 +0100 (CET)
Date:   Tue, 5 Mar 2019 14:30:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@versity.com>
Subject: Re: [PATCH resend 2/2] btrfs-progs: defrag: open files RO on new
 enough kernels
Message-ID: <20190305133022.GY31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@versity.com>
References: <20190225181644.10262-1-kilobyte@angband.pl>
 <20190225181644.10262-2-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225181644.10262-2-kilobyte@angband.pl>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 07:16:44PM +0100, Adam Borowski wrote:
> Defragging an executable conflicts both way with it being run, resulting in
> ETXTBSY.  This either makes defrag fail or prevents the program from being
> executed.
> 
> Kernels 4.19-rc1 and later allow defragging files you could have possibly
> opened rw, even if the passed descriptor is ro (commit 616d374efa23).
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Applied, thanks.
