Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FD3C7618B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 15:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D7422BF5
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 15:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389614AbfGYPui (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 11:50:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:46076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389567AbfGYPui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 11:50:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 002E0AF6B
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 15:50:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04327DA7DE; Thu, 25 Jul 2019 17:51:13 +0200 (CEST)
Date:   Thu, 25 Jul 2019 17:51:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Return number of compressed extents directly
 in compress_file_range
Message-ID: <20190725155113.GU2868@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190717114145.27731-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717114145.27731-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 17, 2019 at 02:41:44PM +0300, Nikolay Borisov wrote:
> compress_file_range returns a void, yet uses a function parameter as a
> return value. Make that more idiomatic by simply returning the number
> of compressed extents directly. Also track such extents in more aptly
> named variables. No functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

1 and 2 added to misc-next, thanks.
