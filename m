Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:47918 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3EXTu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 15:50:26 -0400
Received: by mail-wg0-f53.google.com with SMTP id m15so2894860wgh.8
        for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 12:50:24 -0700 (PDT)
Message-ID: <519FC476.1060206@gmail.com>
Date: Fri, 24 May 2013 21:50:14 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
References: <1369160908-26195-1-git-send-email-mfasheh@suse.de> <1369160908-26195-5-git-send-email-mfasheh@suse.de> <20130524140536.GQ5187@twin.jikos.cz> <20130524181706.GA5639@wotan.suse.de>
In-Reply-To: <20130524181706.GA5639@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> +#define BTRFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
>>> +#define BTRFS_ONE_DEDUPE_LEN	(1 * 1024 * 1024)
>>> +
>>> +static long btrfs_ioctl_file_extent_same(struct file *file,
>>> +					 void __user *argp)
>>> +{
>>> +	struct btrfs_ioctl_same_args *args;
>>> +	struct btrfs_ioctl_same_args tmp;
>>> +	struct btrfs_ioctl_same_extent_info *info;
>>> +	struct inode *src = file->f_dentry->d_inode;
>>> +	struct file *dst_file = NULL;
>>> +	struct inode *dst;
>>> +	u64 off;
>>> +	u64 len;
>>> +	int args_size;
>>> +	int i;
>>> +	int ret;
>>> +	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
>>
>> The ioctl is available to non-root, so an extra care should be taken to
>> potentail overflows etc. I haven't spotted anything so far.
> 
> 
> Sure. Actually, you got me thinking about some sanity checks... I need to
> add at least this check:
> 
> 	if (btrfs_root_readonly(root))
> 		return -EROFS;
> 
> which isn't in there as of now.

It's not needed and I'd rather do without, read-only snapshots and deduplication go together well for backups.
Data and metadata are guaranteed to be immutable, extent storage isn't.  This is also the case with raid.


> Also I don't really check the open mode (read, write, etc) on files passed
> in. We do this in the clone ioctl and it makes sense there since data (to
> the user) can change. With this ioctl though data won't ever change (even if
> the underlying extent does). So I left the checks out. A part of me is
> thinking we might want to be conservative to start with though and just add
> those type of checks in. Basically, I figure the source should be open for
> read at least and target files need write access.

I don't know of any privileged files that one would be able to open(2), but if this is available to unprivileged users the files all need to be open for reading so that it can't be used to guess at their contents.
As long as root gets to bypass the checks (no btrfs_root_readonly) it doesn't hurt my use case.

