Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE937C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 15:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 820BB217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 15:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfDRPsK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:48:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:40146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387519AbfDRPsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 11:48:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8080B090
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 15:48:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 42C80DA991; Thu, 18 Apr 2019 17:49:14 +0200 (CEST)
Date:   Thu, 18 Apr 2019 17:49:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Cleanup btrfs_destroy_delayed_refs()
Message-ID: <20190418154913.GO20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190416055739.25771-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416055739.25771-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 01:57:39PM +0800, Qu Wenruo wrote:
> This patches cleans up btrfs_destroy_delayed_refs() by:
> - Remove the forward declaration
>   The caller comes after the implementation, no need to do forward
>   declaration.

Ok.

> - Remove the @fs_info parameter
>   @fs_info can be extracted from @trans parameter.

Ok.

> - Make it return void
>   Again, no failure pattern.

When switching a fuction to return void, please check the whole
callgraph for functions that do not properly handler errors and do
BUG_ON. You won't see errors passed from them so this gives the
impression no error handling is needed in the caller.

This has been sent in the past, so I can point you to the 2nd paragraph in
https://lore.kernel.org/linux-btrfs/20180815124425.GM24025@twin.jikos.cz/

hint: btrfs_pin_extent
