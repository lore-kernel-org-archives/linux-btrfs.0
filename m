Return-Path: <SRS0=NN0a=4U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AC0C3F2C6
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DC892083E
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgCCPez (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:34:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:35456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbgCCPez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Mar 2020 10:34:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DC01FB138;
        Tue,  3 Mar 2020 15:34:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F31C4DA7AE; Tue,  3 Mar 2020 16:34:31 +0100 (CET)
Date:   Tue, 3 Mar 2020 16:34:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] btrfs: clear BTRFS_ROOT_DEAD_RELOC_TREE before
 dropping the reloc root
Message-ID: <20200303153431.GF2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20200302184757.44176-1-josef@toxicpanda.com>
 <20200302184757.44176-6-josef@toxicpanda.com>
 <20200302193120.GS2902@twin.jikos.cz>
 <ab3e1533-d0e3-8ab7-0d72-acf71ce66968@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab3e1533-d0e3-8ab7-0d72-acf71ce66968@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 02, 2020 at 02:51:11PM -0500, Josef Bacik wrote:
> On 3/2/20 2:31 PM, David Sterba wrote:
> > On Mon, Mar 02, 2020 at 01:47:55PM -0500, Josef Bacik wrote:
> >> We were doing the clear dance for the reloc root after doing the drop of
> >> the reloc root, which means we have a giant window where we could miss
> >> having BTRFS_ROOT_DEAD_RELOC_TREE unset and the reloc_root == NULL.
> >>
> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >> ---
> >>   fs/btrfs/relocation.c | 13 +++++++------
> >>   1 file changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> >> index e60450c44406..acd21c156378 100644
> >> --- a/fs/btrfs/relocation.c
> >> +++ b/fs/btrfs/relocation.c
> >> @@ -2291,18 +2291,19 @@ static int clean_dirty_subvols(struct reloc_control *rc)
> >>   
> >>   			list_del_init(&root->reloc_dirty_list);
> >>   			root->reloc_root = NULL;
> >> -			if (reloc_root) {
> >> -
> >> -				ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
> >> -				if (ret2 < 0 && !ret)
> >> -					ret = ret2;
> >> -			}
> >>   			/*
> >>   			 * Need barrier to ensure clear_bit() only happens after
> >>   			 * root->reloc_root = NULL. Pairs with have_reloc_root.
> >>   			 */
> >>   			smp_wmb();
> >>   			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
> >> +
> >> +			if (reloc_root) {
> >> +
> >> +				ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
> >> +				if (ret2 < 0 && !ret)
> >> +					ret = ret2;
> >> +			}
> > 
> > This reverts fix 1fac4a54374f7ef385938f3c6cf7649c0fe4f6cd that moved if
> > (reloc_root) before the clear_bit.
> > 
> 
> Hmm we should probably keep this and move the
> 
> if (root->reloc_root)
> 
> thing after the
> 
>          if (!rc || !rc->create_reloc_tree ||
>              root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
>                  return 0;
> 
> to properly fix this.  I'll add this and send an updated series.  Thanks,

Also please update the changelog, it's too vague for a code that had
several bugs regarding the reloc_root lifetime.
