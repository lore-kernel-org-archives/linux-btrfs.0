Return-Path: <SRS0=lmmL=UE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D960C28CC5
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Jun 2019 16:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C9EB2083E
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Jun 2019 16:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfFEQi3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:38:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:33142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728263AbfFEQi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jun 2019 12:38:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20CB5AC3F
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Jun 2019 16:38:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 840A0DA866; Wed,  5 Jun 2019 18:39:19 +0200 (CEST)
Date:   Wed, 5 Jun 2019 18:39:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: Metadata preallocation enhancement
Message-ID: <20190605163919.GG9896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190416102144.12173-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416102144.12173-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:21:42PM +0800, Qu Wenruo wrote:
> This patchset will address the github issue #123 to make btrfs-convert
> less possible to report false ENOSPC.
> 
> The first patch will try to avoid the nested chunk/extent tree
> modification in a more explicit way.
> 
> The 2nd patch will address the ENOSPC problem, by adding CSUM tree to
> the metadata preallocate list.
> 
> The 2nd patch is not as aggressive as 7a12d8470e5f ("btrfs-progs:
> Do metadata preallocation as long as we're not modifying extent tree").
> Even we have the 1st patch I still prefer to make less modification to
> avoid possible bugs.
> 
> Qu Wenruo (2):
>   btrfs-progs: Avoid nested chunk allocation call
>   btrfs-progs: Do metadata preallocation for fs trees and csum tree

Added to devel, thanks.
