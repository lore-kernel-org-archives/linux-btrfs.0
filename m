Return-Path: <SRS0=JIB5=BU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68472C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Aug 2020 15:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4122022D37
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Aug 2020 15:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgHJPyE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 11:54:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:39390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgHJPyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Aug 2020 11:54:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0C73EAB55;
        Mon, 10 Aug 2020 15:54:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D3B63DA7D5; Mon, 10 Aug 2020 17:53:01 +0200 (CEST)
Date:   Mon, 10 Aug 2020 17:53:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Rework error detection in init_tree_roots
Message-ID: <20200810155301.GE2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20200804073236.6677-1-nborisov@suse.com>
 <SN4PR0401MB35982C96F01F6CD1AFB31C679B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <327aaaeb-affd-e762-921d-f2f823eec3bc@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <327aaaeb-affd-e762-921d-f2f823eec3bc@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 04, 2020 at 06:02:58PM +0300, Nikolay Borisov wrote:
> 
> 
> On 4.08.20 г. 15:58 ч., Johannes Thumshirn wrote:
> > On 04/08/2020 09:32, Nikolay Borisov wrote:
> >> @@ -2645,17 +2645,16 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
> >>  		level = btrfs_super_root_level(sb);
> >>  		tree_root->node = read_tree_block(fs_info, btrfs_super_root(sb),
> >>  						  generation, level, NULL);
> >> -		if (IS_ERR(tree_root->node) ||
> >> -		    !extent_buffer_uptodate(tree_root->node)) {
> >> +		if (IS_ERR(tree_root->node)) {
> >>  			handle_error = true;
> >> +			ret = PTR_ERR(tree_root->node);
> >> +			tree_root->node = NULL;
> >> +			btrfs_warn(fs_info, "failed to read tree root");
> >> +			continue;
> > 
> > [...]
> > 
> >>  			btrfs_warn(fs_info, "failed to read tree root");
> >>  			continue;
> >>  		}
> > 
> > Now we're duplicating the warning message. I think it's better to have two 
> > distinct messages so we can differentiate which of the two failure cases happened.
> > 
> > The 2nd one could be something like "tree root eb not uptodate".
> 
> Sure, I'm happy too replace it with whatever is more informative. Will
> take another look at the code and see what I can derive.

The errors are different, IS_ERR is because the block was not read at
all for some reason, extent_buffer_uptodate is EIO in all other places
that do this kind of check.

Here it's EUCLEAN and it's been like that since the beginning but I
think it should be EIO.
