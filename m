Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:33883 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcBELjJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Feb 2016 06:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <20160204141436.GB9136@twin.jikos.cz>
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
	<1454479670-8204-11-git-send-email-deepa.kernel@gmail.com>
	<20160204141436.GB9136@twin.jikos.cz>
Date: Fri, 5 Feb 2016 03:39:08 -0800
Message-ID: <CABeXuvqBYcgrMzjqesz+m37A3UzxCixkWvg8OyO5AdraMnQu-Q@mail.gmail.com>
Subject: Re: [PATCH 10/10] fs: btrfs: Replace CURRENT_TIME by current_fs_time()
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: dsterba@suse.cz, Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel tester found a dereferencing NULL pointer issue with this patch.

I think this is the fix:

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -488,7 +488,7 @@ void btrfs_update_root_times(struct
btrfs_trans_handle *trans,
                             struct btrfs_root *root)
 {
        struct btrfs_root_item *item = &root->root_item;
-       struct timespec ct = current_fs_time(root->ino_cache_inode->i_sb);
+       struct timespec ct = current_fs_time(root->fs_info->sb);


I will test and re-post the patch.

-Deepa

On Thu, Feb 4, 2016 at 6:14 AM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Feb 02, 2016 at 10:07:50PM -0800, Deepa Dinamani wrote:
>> CURRENT_TIME macro is not appropriate for filesystems as it
>> doesn't use the right granularity for filesystem timestamps.
>> Use current_fs_time() instead.
>>
>> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
>> Cc: Chris Mason <clm@fb.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Cc: David Sterba <dsterba@suse.com>
>> Cc: linux-btrfs@vger.kernel.org
>
> Reviewed-by: David Sterba <dsterba@suse.com>
>
> There's no actual change for btrfs as it uses granularity 1 which is a
> no-op and equivalent to CURRENT_TIME.
