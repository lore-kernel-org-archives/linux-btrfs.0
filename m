Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A135C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A139206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A139206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394909AbeKXAaC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 19:30:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:45034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388242AbeKXAaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 19:30:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7ACFFAF93;
        Fri, 23 Nov 2018 13:45:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 785FFDA858; Fri, 23 Nov 2018 14:45:27 +0100 (CET)
Date:   Fri, 23 Nov 2018 14:45:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/6] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20181123134525.GC2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-2-josef@toxicpanda.com>
 <9e2495bc-4bcc-046c-2416-415a7e48c681@suse.com>
 <3eb452b8-d07f-530e-a16e-8d8fd5938b87@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3eb452b8-d07f-530e-a16e-8d8fd5938b87@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 11:42:28AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.11.18 г. 11:12 ч., Nikolay Borisov wrote:
> > 
> > 
> > On 21.11.18 г. 20:59 ч., Josef Bacik wrote:
> >> From: Josef Bacik <jbacik@fb.com>
> >>
> >> We do this dance in cleanup_ref_head and check_ref_cleanup, unify it
> >> into a helper and cleanup the calling functions.
> >>
> >> Signed-off-by: Josef Bacik <jbacik@fb.com>
> >> Reviewed-by: Omar Sandoval <osandov@fb.com>
> >> ---
> >>  fs/btrfs/delayed-ref.c | 14 ++++++++++++++
> >>  fs/btrfs/delayed-ref.h |  3 ++-
> >>  fs/btrfs/extent-tree.c | 22 +++-------------------
> >>  3 files changed, 19 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> >> index 9301b3ad9217..b3e4c9fcb664 100644
> >> --- a/fs/btrfs/delayed-ref.c
> >> +++ b/fs/btrfs/delayed-ref.c
> >> @@ -400,6 +400,20 @@ struct btrfs_delayed_ref_head *btrfs_select_ref_head(
> >>  	return head;
> >>  }
> >>  
> >> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> >> +			   struct btrfs_delayed_ref_head *head)
> >> +{
> >> +	lockdep_assert_held(&delayed_refs->lock);
> >> +	lockdep_assert_held(&head->lock);
> >> +
> >> +	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> >> +	RB_CLEAR_NODE(&head->href_node);
> >> +	atomic_dec(&delayed_refs->num_entries);
> >> +	delayed_refs->num_heads--;
> >> +	if (head->processing == 0)
> >> +		delayed_refs->num_heads_ready--;
> > 
> > num_heads_ready will never execute in cleanup_ref_head, since
> > processing == 0 only when the ref head is unselected. Perhaps those 2
> > lines shouldn't be in this function? I find it a bit confusing that if
> > processing is 0 we decrement num_heads_ready in check_ref_cleanup, but
> > in unselect_delayed_ref_head we set it to 0 and increment it.
> > 
> >> +}
> >> +
> >>  /*
> >>   * Helper to insert the ref_node to the tail or merge with tail.
> >>   *
> >> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> >> index 8e20c5cb5404..d2af974f68a1 100644
> >> --- a/fs/btrfs/delayed-ref.h
> >> +++ b/fs/btrfs/delayed-ref.h
> >> @@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
> >>  {
> >>  	mutex_unlock(&head->mutex);
> >>  }
> >> -
> >> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> >> +			   struct btrfs_delayed_ref_head *head);
> >>  
> >>  struct btrfs_delayed_ref_head *btrfs_select_ref_head(
> >>  		struct btrfs_delayed_ref_root *delayed_refs);
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index d242a1174e50..c36b3a42f2bb 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -2474,12 +2474,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> >>  		spin_unlock(&delayed_refs->lock);
> >>  		return 1;
> >>  	}
> >> -	delayed_refs->num_heads--;
> >> -	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> >> -	RB_CLEAR_NODE(&head->href_node);
> >> +	btrfs_delete_ref_head(delayed_refs, head);
> >>  	spin_unlock(&head->lock);
> >>  	spin_unlock(&delayed_refs->lock);
> >> -	atomic_dec(&delayed_refs->num_entries);
> >>  
> >>  	trace_run_delayed_ref_head(fs_info, head, 0);
> >>  
> >> @@ -6984,22 +6981,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
> >>  	if (!mutex_trylock(&head->mutex))
> >>  		goto out;
> >>  
> >> -	/*
> >> -	 * at this point we have a head with no other entries.  Go
> >> -	 * ahead and process it.
> >> -	 */
> >> -	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> >> -	RB_CLEAR_NODE(&head->href_node);
> >> -	atomic_dec(&delayed_refs->num_entries);
> >> -
> >> -	/*
> >> -	 * we don't take a ref on the node because we're removing it from the
> >> -	 * tree, so we just steal the ref the tree was holding.
> >> -	 */
> >> -	delayed_refs->num_heads--;
> >> -	if (head->processing == 0)
> >> -		delayed_refs->num_heads_ready--;
> >> +	btrfs_delete_ref_head(delayed_refs, head);
> >>  	head->processing = 0;
> 
> On a closer inspection I think here we can do:
> 
> ASSERT(head->processing == 0) because at that point we've taken the
> head->lock spinlock which is held during ordinary delayed refs
> processing (in __btrfs_run_delayed_refs) when the head is selected (and
> processing is 1). So head->processing == 0 here I think is a hard
> invariant of the code. The decrement here should pair with the increment
> when the head was initially added to the tree.
> 
> In cleanup_ref_head we don't need to ever worry about num_heads_ready
> since it has already been decremented by btrfs_select_ref_head.
> 
> As a matter fact this counter is not used anywhere so we might as well
> just remove it.

The logic does not use it, there's only a WARN_ON in
btrfs_select_ref_head, that's more like a debugging or assertion that
everything is fine. So the question is whether to keep it as a
consistency check (and add comments) or remove it and simplify the code.
