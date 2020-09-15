Return-Path: <SRS0=LHCx=CY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CECC433E2
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Sep 2020 07:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D053121D1B
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Sep 2020 07:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgIOHq7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:46:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:60748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIOHqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Sep 2020 03:46:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62EB6AE84;
        Tue, 15 Sep 2020 07:46:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C4649DA7C7; Tue, 15 Sep 2020 09:44:53 +0200 (CEST)
Date:   Tue, 15 Sep 2020 09:44:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Opencode extent_read_full_page to its sole caller
Message-ID: <20200915074453.GD1791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200914093711.13523-1-nborisov@suse.com>
 <20200914113916.29852-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914113916.29852-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 14, 2020 at 02:39:16PM +0300, Nikolay Borisov wrote:
> This makes reading the code a tad easier by decreasing the level of
> indirection by one.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> David,
> 
> Here is a followup patch based on Johaness' feedback if you could merge it
> after having merged the whole series I'll much appreciated it.

Sure, added to the rest.
