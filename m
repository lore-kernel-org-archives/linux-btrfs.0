Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99733C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 15:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62DAA20873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 15:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62DAA20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbeK1ChM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 21:37:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:50416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729099AbeK1ChL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 21:37:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 733DCAD66;
        Tue, 27 Nov 2018 15:38:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B02B4DAC3A; Tue, 27 Nov 2018 16:38:36 +0100 (CET)
Date:   Tue, 27 Nov 2018 16:38:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 5/6] btrfs: introduce delayed_refs_rsv
Message-ID: <20181127153836.GK2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-6-josef@toxicpanda.com>
 <3ca2ff06-6efa-e371-28ad-fb2ccf387f35@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca2ff06-6efa-e371-28ad-fb2ccf387f35@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 11:14:12AM +0200, Nikolay Borisov wrote:
> > -	if (global_rsv->space_info->full) {
> > -		num_dirty_bgs_bytes <<= 1;
> > -		num_bytes <<= 1;
> > -	}
> > +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 reserved;
> > +	bool ret = false;
> 
> nit: Reverse christmas tree:

Let it be known that the reverse-xmas-tree declaration style will _not_
be enforced in new patches and cleanup patches only reordering
declarations will not be accepted.

You're free to use it but I may edit your patch so the declaration
conforms to the style used in the file or to a pattern that's common the
subsystem, eg. global pointers like fs_info or root first in the list.
