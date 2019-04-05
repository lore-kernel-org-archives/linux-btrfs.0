Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD47C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 12:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4526D21871
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 12:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfDEMIo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 08:08:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:51378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfDEMIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 08:08:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0AF3AD55
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 12:08:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 92FA8DA847; Fri,  5 Apr 2019 14:09:50 +0200 (CEST)
Date:   Fri, 5 Apr 2019 14:09:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
Message-ID: <20190405120950.GW29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404064537.4031-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 02:45:29PM +0800, Qu Wenruo wrote:
> Current delayed ref interface has several problems:
> - Longer and longer parameter lists
>   bytenr
>   num_bytes
>   parent
>   ---------- so far so good
>   ref_root
>   owner
>   offset
>   ---------- I don't feel good now
> 
> - Different interpretation for the same parameter
>   Above @owner for data ref is inode number (u64),
>   while for tree ref, it's level (int).
> 
>   They are even in different size range.
>   For level we only need 0~8, while for ino it's
>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.
> 
>   And @offset doesn't even makes sense for tree ref.
> 
>   Such parameter reuse may look clever as an hidden union, but it
>   destroys code readability.
> 
> To solve both problems, we introduce a new structure, btrfs_ref to solve
> them:
> 
> - Structure instead of long parameter list
>   This makes later expansion easier, and better documented.
> 
> - Use btrfs_ref::type to distinguish data and tree ref
> 
> - Use proper union to store data/tree ref specific structures.
> 
> - Use separate functions to fill data/tree ref data, with a common generic
>   function to fill common bytenr/num_bytes members.
> 
> All parameters will find its place in btrfs_ref, and an extra member,
> @real_root, inspired by ref-verify code, is newly introduced for later
> qgroup code, to record which tree is triggered this extent modification.
> 
> This patch doesn't touch any code, but provides the basis for incoming
> refactors.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-ref.h | 116 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 116 insertions(+)
> 
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 70606da440aa..8eb5b3576759 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -176,6 +176,90 @@ struct btrfs_delayed_ref_root {
>  	u64 qgroup_to_skip;
>  };
>  
> +enum btrfs_ref_type {
> +	BTRFS_REF_NOT_SET,
> +	BTRFS_REF_DATA,
> +	BTRFS_REF_METADATA,
> +	BTRFS_REF_LAST,
> +};
> +
> +struct btrfs_data_ref {
> +	/* For EXTENT_DATA_REF */
> +
> +	/* Root who refers to this data extent */
> +	u64 ref_root;
> +
> +	/* Inode who refers to this data extent */
> +	u64 ino;
> +
> +	/*
> +	 * file_offset - extent_offset
> +	 *
> +	 * file_offset is the key.offset of the EXTENT_DATA key.
> +	 * extent_offset is btrfs_file_extent_offset() of the EXTENT_DATA data.
> +	 */
> +	u64 offset;
> +};
> +
> +struct btrfs_tree_ref {
> +	/*
> +	 * Level of this tree block
> +	 *
> +	 * Shared for skinny (TREE_BLOCK_REF) and normal tree ref.
> +	 */
> +	int level;
> +
> +	/*
> +	 * Root who refers to this tree block.
> +	 *
> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
> +	 */
> +	u64 root;
> +
> +	/* For non-skinny metadata, no special member needed */
> +};
> +
> +struct btrfs_ref {

The structure name sounds a bit generic, but I think we can keep it
short. There are no other btrfs-specific references that could be
confused, there are 'backrefs', 'delayed-refs' all refering to the
b-tree references.

> +	enum btrfs_ref_type type;
> +	int action;
> +
> +	/*
> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
> +	 * SHARED_DATA_REF) for this extent and its children.
> +	 * Set for reloc trees.
> +	 */
> +	bool only_backreferences:1;

No bool bitfields please, wasn't this mentioned last time?
