Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30256C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Feb 2021 12:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00AB164EC4
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Feb 2021 12:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBSMJa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 07:09:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:36296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBSMJ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Feb 2021 07:09:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48564AC6E;
        Fri, 19 Feb 2021 12:08:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E8347DA813; Fri, 19 Feb 2021 13:06:50 +0100 (CET)
Date:   Fri, 19 Feb 2021 13:06:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: tests: Extend cli/003
Message-ID: <20210219120650.GY1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210125104358.817072-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125104358.817072-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 25, 2021 at 12:43:57PM +0200, Nikolay Borisov wrote:
> Add a test which ensures that when resize is tried on an image instead
> of a directory appropriate warning is produced and the command fails.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to devel with some fixups, thanks.
