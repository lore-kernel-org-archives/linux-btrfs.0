Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C6AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 308F520842
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfCENX2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:23:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:46896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfCENX2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 08:23:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09FACAF9A;
        Tue,  5 Mar 2019 13:23:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A17F3DA851; Tue,  5 Mar 2019 14:24:43 +0100 (CET)
Date:   Tue, 5 Mar 2019 14:24:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@versity.com>
Subject: Re: [PATCH resend 1/2] btrfs-progs: fix kernel version parsing on
 some versions past 3.0
Message-ID: <20190305132442.GX31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@versity.com>
References: <20190225181644.10262-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225181644.10262-1-kilobyte@angband.pl>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 07:16:43PM +0100, Adam Borowski wrote:
> The code fails if the third section is missing (like "4.18") or is followed
> by anything but "." or "-".  This happens for example if we're not exactly
> at a tag and CONFIG_LOCALVERSION_AUTO=n (which results in "4.18.5+").
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Applied, thanks.
