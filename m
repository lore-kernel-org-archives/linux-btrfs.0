Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B713CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 18:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9389A20863
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 18:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfCRSid (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 14:38:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:49830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbfCRSic (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 14:38:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2672AC38
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 18:38:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39D39DA829; Mon, 18 Mar 2019 19:39:46 +0100 (CET)
Date:   Mon, 18 Mar 2019 19:39:46 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Remove EXTENT_IOBITS
Message-ID: <20190318183945.GE3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190314132831.8749-1-nborisov@suse.com>
 <20190314132831.8749-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314132831.8749-2-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 03:28:31PM +0200, Nikolay Borisov wrote:
> This flag just became synonymous to EXTENT_LOCKED, so just remove it and
> used EXTENT_LOCKED directly. No functional changes.

Ok. The only reason to have an alias would be to make it explicit that
it's for IO, but _LOCKED is used in that context too in other places so
I don't think we're losing any information here.

Reviewed-by: David Sterba <dsterba@suse.com>

1 and 2 added to misc-next, thanks.
