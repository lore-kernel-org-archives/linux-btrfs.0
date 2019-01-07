Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAA0C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74932085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfAGR6z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:58:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:44170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbfAGR6z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 12:58:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07D8CAD38
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 17:58:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 562AFDA7E8; Mon,  7 Jan 2019 18:58:22 +0100 (CET)
Date:   Mon, 7 Jan 2019 18:58:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: Refactor shrink_delalloc
Message-ID: <20190107175820.GZ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-8-nborisov@suse.com>
 <20190104153543.GR23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104153543.GR23615@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 04:35:43PM +0100, David Sterba wrote:
> > @@ -4743,7 +4743,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
> >  	struct btrfs_space_info *space_info;
> >  	struct btrfs_trans_handle *trans;
> >  	u64 delalloc_bytes;
> > -	u64 max_reclaim;
> > +	u64 async_pages;
> 
> This could be int, as it's compared to an atomic_t, otherwise ok.

As this is a different change, please send a separate patch, I've
applied the rename to misc-next.
