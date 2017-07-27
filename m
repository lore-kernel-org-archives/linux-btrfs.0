Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60981 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdG0TL6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:11:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1daoCH-0002eV-Qz
        for linux-btrfs@vger.kernel.org; Thu, 27 Jul 2017 21:11:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] Btrfs: Do not use data_alloc_cluster in ssd mode
Date: Thu, 27 Jul 2017 19:11:38 +0000 (UTC)
Message-ID: <pan$12971$566fe832$ff60933c$6921c466@cox.net>
References: <20170726195925.10715-1-hans.van.kranenburg@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Wed, 26 Jul 2017 21:59:25 +0200 as
excerpted:

> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4f8f75d9e839..b091dd3f5b38 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -472,7 +472,7 @@ struct btrfs_block_rsv {
>  /*
>   * free clusters are used to claim free space in relatively large chunks,
>   * allowing us to do less seeky writes.  They are used for all metadata
> - * allocations and data allocations in ssd mode.
> + * allocations and data allocations in ssd_spread mode.
>   */
>  struct btrfs_free_cluster {
>  	spinlock_t lock;

That (post-patch) comment says all metadata and data allocations in
ssd_spread mode, but if my understanding is correct, it'll also use
free clusters for metadata (only, not data, the patch only changing)
the data behavior) in normal ssd mode.

Perhaps that (metadata only use of free clusers in ssd mode) should be
mentioned as well, since post-patch there's now a distinction to be made?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

