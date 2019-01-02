Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98381C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6638821871
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfABQb7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:31:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:39016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729365AbfABQb7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 11:31:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B20FAEA5;
        Wed,  2 Jan 2019 16:31:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D3936DA781; Wed,  2 Jan 2019 17:31:28 +0100 (CET)
Date:   Wed, 2 Jan 2019 17:31:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Su Yue <Damenly_Su@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
Message-ID: <20190102163128.GY23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yue <Damenly_Su@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <48804351-b8b3-b876-529a-807d05259664@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48804351-b8b3-b876-529a-807d05259664@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 27, 2018 at 07:28:40PM +0800, Su Yue wrote:
> > +}
> > +
> > +int create_uuid_tree(struct btrfs_trans_handle *trans)
> > +{
> > +	struct btrfs_fs_info *fs_info = trans->fs_info;
> > +	struct btrfs_root *uuid_root = fs_info->uuid_root;
> > +	struct btrfs_key key;
> > +	int ret;
> > +
> > +	if (!uuid_root) {
> > +		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
> > +		if (ret < 0) {
> > +			errno = -ret;
> > +			error("failed to create uuid root: %m");
> 
> In personal taste, I don't like such assignment.
> Let the community say.

Check eg. 251d32ea5cd1cf74cb52, replaces strerror(errno) with %m and
requires no change. As we're using strerror(-ret) in many places, it's a
followup that needs the extra errno assignment. This is IMO a small cost
on the source code size and the gain in space savings might be
noticeable for embedded devices, but we need to do all the conversions.
