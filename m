Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbcADKBm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jan 2016 05:01:42 -0500
Date: Mon, 4 Jan 2016 10:59:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs-progs: fix endian bugs and clean-ups
Message-ID: <20160104095924.GM4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 04, 2016 at 10:01:28AM +0900, Byongho Lee wrote:
> This is a patch-set after getting running sparse.
> 
> There are two endian patches one is new and the other is Zach Brown's work
> but we lost.  And rest are just for clean-ups.
> 
> v2:
>  - cover-letter:
>     add, 'btrfs-progs' prefix in subject

JFYI, this by itself would not be a reason for a v2, the patch subjects
contained 'progs'.

>  - btrfs-progs: fix using on-disk structure to store in memory data:
>     remove, "Signed-off-by: Zach Brown <zab@redhat.com>" which was for
>     below patch but added by mistake.
>     '[PATCH 4/6] btrfs-progs: fix endian bugs in chunk rebuilding'
> 
> Byongho Lee (6):
>   btrfs-progs: get sparse checking working
>   btrfs-progs: use NULL instead of 0
>   btrfs-progs: make private symbols to static
>   btrfs-progs: fix endian bugs in chunk rebuilding
>   btrfs-progs: fix endian bug in update_super()
>   btrfs-progs: fix using on-disk structure to store in memory data

All applied, thanks.
