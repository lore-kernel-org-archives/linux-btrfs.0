Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbcECRrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 13:47:46 -0400
Date: Tue, 3 May 2016 19:47:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: cleanup assigning next active device with a
 check
Message-ID: <20160503174728.GM29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
 <20160502152618.GK29353@suse.cz>
 <572876FB.4070208@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <572876FB.4070208@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2016 at 06:01:31PM +0800, Anand Jain wrote:
> 
> 
> On 05/02/2016 11:26 PM, David Sterba wrote:
> > On Mon, May 02, 2016 at 07:02:08AM +0800, Anand Jain wrote:
> >> --- a/fs/btrfs/dev-replace.c
> >> +++ b/fs/btrfs/dev-replace.c
> >> @@ -569,11 +569,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
> >>   	ASSERT(list_empty(&src_device->resized_list));
> >>   	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
> >>   	tgt_device->commit_bytes_used = src_device->bytes_used;
> >> -	if (fs_info->sb->s_bdev &&
> >> -		(fs_info->sb->s_bdev == src_device->bdev))
> >> -		fs_info->sb->s_bdev = tgt_device->bdev;
> >
> > What's the base of this patch?
> 
>   It was on master. But now the V3 which is based on your for-next.
> 
> > The above code is not in my for-next so
> > I could be missing some important bits.
> 
>   Yes. That was added by this patch.
> 
>   [PATCH] btrfs: s_bdev is not null after missing replace

Ah, that's the one. Added to next together with v3, though a testcase is
still desirable.

>   While here can also integrate this.
> 
>   [PATCH 1/1] btrfs: fix lock dep warning move scratch super outside of 
> chunk_mutex

That one has been in for-next for some time.
