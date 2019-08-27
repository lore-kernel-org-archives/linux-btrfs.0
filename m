Return-Path: <SRS0=Pg1I=WX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A82DC3A5A3
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 16:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A122186A
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 16:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfH0QDO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 12:03:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:51246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbfH0QDO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Aug 2019 12:03:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35619AEC4
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2019 16:03:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 85215DA8D5; Tue, 27 Aug 2019 18:03:36 +0200 (CEST)
Date:   Tue, 27 Aug 2019 18:03:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Use btrfs_find_name_in_backref in
 backref_in_log
Message-ID: <20190827160336.GQ2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190827114630.2425-1-nborisov@suse.com>
 <20190827114630.2425-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827114630.2425-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 27, 2019 at 02:46:30PM +0300, Nikolay Borisov wrote:
> By not opencoding btrfs_find_name_in_backref most of the local variables
> can be removed, this in turn alleviates stack pressure. Additionally,
> backref_in_log is only used as predicate so make it return bool.

While it is used as bool, it returns error numbers so the callsites
should be updated to distinguish errors from true/false.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/tree-log.c | 57 +++++++++++++--------------------------------
>  1 file changed, 16 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7d45a4869bc9..070016e023b8 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -938,60 +938,35 @@ static noinline int inode_in_dir(struct btrfs_root *root,
>   * want to delete valid links to a file from the subvolume if that
>   * link is also in the log.
>   */
> -static noinline int backref_in_log(struct btrfs_root *log,
> -				   struct btrfs_key *key,
> -				   u64 ref_objectid,
> -				   const char *name, int namelen)
> +static noinline bool backref_in_log(struct btrfs_root *log,
> +				    struct btrfs_key *key,
> +				    u64 ref_objectid,
> +				    const char *name, int namelen)
>  {
>  	struct btrfs_path *path;
> -	struct btrfs_inode_ref *ref;
> -	unsigned long ptr;
> -	unsigned long ptr_end;
> -	unsigned long name_ptr;
> -	int found_name_len;
> -	int item_size;
> +	bool found = false;
>  	int ret;
> -	int match = 0;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> -		return -ENOMEM;
> +		return false;

There would have to be a very good reasoning behind that but I doubt
it's correct.

>  	ret = btrfs_search_slot(NULL, log, key, path, 0, 0);
>  	if (ret != 0)

This should also check for errors, though it's not changed in your
patch.

So if you want to de-opencode btrfs_find_name_in_backref, then fine, but
the other changes should be separate and possibly updating the whole
callchain.
