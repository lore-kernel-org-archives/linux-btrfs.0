Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3871C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8FE2186A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfB1P7V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:59:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:40402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbfB1P7V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 10:59:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BABEAC7F;
        Thu, 28 Feb 2019 15:59:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A8F55DA944; Thu, 28 Feb 2019 17:00:40 +0100 (CET)
Date:   Thu, 28 Feb 2019 17:00:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 06/10] btrfs: start transaction in btrfs_set_prop_trans
Message-ID: <20190228160040.GJ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-7-git-send-email-anand.jain@oracle.com>
 <20190227160826.GT24609@twin.jikos.cz>
 <742192e4-ce6e-df4e-aa64-1145a4e3f44a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <742192e4-ce6e-df4e-aa64-1145a4e3f44a@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 06:36:40PM +0800, Anand Jain wrote:
> >> +	if (!ret) {
> >> +		inode_inc_iversion(inode);
> >> +		inode->i_ctime = current_time(inode);
> >> +		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
> >> +		ret = btrfs_update_inode(trans, root, inode);
> >> +		ASSERT(!ret);
> > 
> > This is not right. The previous code uses BUG_ON which is also not
> > right, but does not silently continue if asserts are compiled out.
> > Please add proper error handling here.
> 
>   Error handling should save and undo of inode version, i_ctime and
>   runtime_flags. Is a new patch for this OK? and here will use BUG_ON
>   as in the original.

Ok, use BUG_ON, it's effectively only a code copy. The error handling
could be tricky here.
