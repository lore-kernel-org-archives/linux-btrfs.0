Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45180C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC0F206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfC1Ngz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:36:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:43602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbfC1Ngz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 09:36:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80772AC5A;
        Thu, 28 Mar 2019 13:36:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A995EDA8D8; Thu, 28 Mar 2019 14:38:06 +0100 (CET)
Date:   Thu, 28 Mar 2019 14:38:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Message-ID: <20190328133806.GD29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320063717.31770-9-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:37:16PM +0800, Qu Wenruo wrote:
> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "invalid nlink: has %u expect no more than 1 for dir",
> +			btrfs_inode_nlink(leaf, iitem));
> +		goto error;
> +	}

I'm not sure about this check, the number of links for a directory is 1,
but the exact count could be implemented (there's a project idea for
that). I don't know if this will require an incompat bit or not.

As long as the number is not authoritative (ie. can be verified and
fixed from the actual directory items), then I'd say don't check it at
all, or perhaps do only weak check if it's > 0.

Out of all the verified inode data, this is the least important, I think
we're not losing some significant piece of information.
