Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([125.16.236.8]:49457 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcAFIha (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 03:37:30 -0500
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 6 Jan 2016 14:07:27 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 818641258059
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2016 14:08:08 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u068bNHK524678
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Jan 2016 14:07:24 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u068bM8N004279
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Jan 2016 14:07:23 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when loading tree root and subvolume roots
Date: Wed, 06 Jan 2016 14:07:22 +0530
Message-ID: <4286363.m0GjBevCRf@localhost.localdomain>
In-Reply-To: <20160105121234.GT4227@twin.jikos.cz>
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com> <8703019.0plYdL21k7@localhost.localdomain> <20160105121234.GT4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 05 Jan 2016 13:12:34 David Sterba wrote:
> Sorry for not answering that. As you're going to resend it, please
> use EOVERFLOW in the btrfs_init_fs_root. We should not hit the overflow
> error in the mount path.
Right. Now I understand that.

David, Replacing the following code snippet instances (in both open_ctree()
and btrfs_init_fs_root()) ...

        if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
                mutex_unlock(&root->objectid_mutex);
                ret = -EOVERFLOW;
                goto free_root_dev;
        }

with ....

     ASSERT(tree_root->highest_objectid <= BTRFS_LAST_FREE_OBJECTID);

is probably a better option?

The validation of root->highest_objectid must have been done by
btrfs_find_free_objectid() when creating the subvolume. If the parent
subvolume already has an objectid with BTRFS_LAST_FREE_OBJECTID as the value,
btrfs_find_free_objectid() would return with an error and hence we should
never have subvolumes containing other subvolumes with objectid greater than
BTRFS_LAST_FREE_OBJECTID.

-- 
chandan

