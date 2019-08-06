Return-Path: <SRS0=BA/r=WC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B523C433FF
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 16:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB94A20B1F
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 16:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbfHFQsn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Aug 2019 12:48:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:52670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbfHFQsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Aug 2019 12:48:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 894A2AEB3;
        Tue,  6 Aug 2019 16:48:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76281DA7D7; Tue,  6 Aug 2019 18:49:14 +0200 (CEST)
Date:   Tue, 6 Aug 2019 18:49:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <hans@knorrie.org>
Cc:     linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Re: [PATCH] btrfs-progs: docs: fix label property description
Message-ID: <20190806164913.GO28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Hans van Kranenburg <hans@knorrie.org>,
        linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
References: <20190803214403.1040-1-hans@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190803214403.1040-1-hans@knorrie.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 03, 2019 at 11:44:03PM +0200, Hans van Kranenburg wrote:
> From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> 
> Recently, commit c9da5695b2 improved the description for the label
> property, to clarify it's a filesystem property, and not a device
> property. Follow this change in the man page for btrfs-property.
> 
> Also add a little hint about what to specify as object.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Applied, thanks.
