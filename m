Return-Path: <SRS0=UWtY=4X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95416C10F27
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 19:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6F620675
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 19:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFThk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 14:37:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:56004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgCFThj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Mar 2020 14:37:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0820AEEF;
        Fri,  6 Mar 2020 19:37:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 860CDDA728; Fri,  6 Mar 2020 20:37:13 +0100 (CET)
Date:   Fri, 6 Mar 2020 20:37:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     madhuparnabhowmik10@gmail.com
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        frextrite@gmail.com, linux@roeck-us.net
Subject: Re: [PATCH] fs: btrfs: block-group.c: Fix suspicious RCU usage
 warning
Message-ID: <20200306193713.GI2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, madhuparnabhowmik10@gmail.com,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        frextrite@gmail.com, linux@roeck-us.net
References: <20200306065243.11699-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306065243.11699-1-madhuparnabhowmik10@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 06, 2020 at 12:22:43PM +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> The space_info list is rcu protected.
> Hence, it should be traversed with rcu_read_lock held.
> 
> Warning:
> [   29.104591] =============================
> [   29.104756] WARNING: suspicious RCU usage
> [   29.105046] 5.6.0-rc4-next-20200305 #1 Not tainted
> [   29.105231] -----------------------------
> [   29.105401] fs/btrfs/block-group.c:2011 RCU-list traversed in non-reader section!!
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

I've updated the changelog based on comments from the mail thread and
applied the patch. Thanks.
