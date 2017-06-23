Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:54720 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdFWP37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 11:29:59 -0400
Subject: Re: [PATCH] btrfs: fix integer overflow in calc_reclaim_items_nr
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: davej@codemonkey.org.uk
References: <20170623143240.1245989-1-clm@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <b033955e-c0ff-20da-0e98-f68a5eb767c8@applied-asynchrony.com>
Date: Fri, 23 Jun 2017 17:29:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170623143240.1245989-1-clm@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/17 16:32, Chris Mason wrote:
[..]
> -static inline int calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
> +static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
>  					u64 to_reclaim)
>  {
>  	u64 bytes;
> -	int nr;
> +	u64 nr;
>  
>  	bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
>  	nr = (int)div64_u64(to_reclaim, bytes);
        ^^^^^^^^^^

Isn't this a bit odd? I can't even tell whether it matters, just randomly
noticed it because I genuinely dislike type casts..

-h
