Return-Path: <SRS0=Ri2p=4V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F51C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73BD720838
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgCDOgd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 09:36:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:51062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgCDOgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Mar 2020 09:36:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D572AD41;
        Wed,  4 Mar 2020 14:36:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 889EDDA7B4; Wed,  4 Mar 2020 15:36:08 +0100 (CET)
Date:   Wed, 4 Mar 2020 15:36:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Michael Lass <bevan@bi-co.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: allow passing options to qgroup
 remove
Message-ID: <20200304143608.GV2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Michael Lass <bevan@bi-co.net>,
        linux-btrfs@vger.kernel.org
References: <20200202144542.98625-1-bevan@bi-co.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200202144542.98625-1-bevan@bi-co.net>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Feb 02, 2020 at 03:45:42PM +0100, Michael Lass wrote:
> According to the documentation, btrfs qgroup remove takes the same
> options as qgroup assign, i.e., --rescan and --no-rescan. However,
> currently no options are accepted. Activate option handling also for
> qgroup remove, so that automatic rescan can be disabled by the user.
> 
> Signed-off-by: Michael Lass <bevan@bi-co.net>

Thanks, patch applied. I've copied the options in the manual page to
'remove' so it's stated explicitly and not just a reference to 'assign'.
