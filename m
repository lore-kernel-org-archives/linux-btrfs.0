Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC96BC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 988EB651B2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCIPjy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:39:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:35134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhCIPjr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Mar 2021 10:39:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5BFF5AE15;
        Tue,  9 Mar 2021 15:39:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15731DA7D7; Tue,  9 Mar 2021 16:37:48 +0100 (CET)
Date:   Tue, 9 Mar 2021 16:37:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sidong Yang <realwakka@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs-progs: filesystem-resize: make output more
 readable
Message-ID: <20210309153747.GJ7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sidong Yang <realwakka@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20210220124117.11444-1-realwakka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220124117.11444-1-realwakka@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 20, 2021 at 12:41:17PM +0000, Sidong Yang wrote:
> This patch make output of filesystem-resize command more readable and
> give detail information for users. This patch provides more information
> about filesystem like below.
> 
> Before:
> Resize '/mnt' of '1:-1G'
> 
> After:
> Resize device id 1 (/dev/vdb) from 4.00GiB to 3.00GiB
> 
> Signed-off-by: Sidong Yang <realwakka@gmail.com>

Added to devel, thanks.
