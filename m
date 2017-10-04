Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45051 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752242AbdJDPCX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 11:02:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01EABAD06
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Oct 2017 15:02:22 +0000 (UTC)
Date: Wed, 4 Oct 2017 17:00:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH v3 2/2] btrfs: Remove received_uuid during received
 snapshot ro->rw switch
Message-ID: <20171004150039.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927140007.GH31640@twin.jikos.cz>
 <1506585198-32494-1-git-send-email-nborisov@suse.com>
 <1506585198-32494-2-git-send-email-nborisov@suse.com>
 <20170929175645.GV31640@twin.jikos.cz>
 <d1ad211a-fa4a-8aed-3327-81610277679a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d1ad211a-fa4a-8aed-3327-81610277679a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 10:15:30PM +0300, Nikolay Borisov wrote:
> > Adding the transaction before the "if (flags & BTRFS_SUBVOL_RDONLY)"
> > condition makes it much worse. The "is subvolume in send" test is
> > supposed to be lightweight and should not shoot down the whole
> > filesystem. The usecase is explained in 2c68653787f91c62f8.
> > 
> > Also the received_uuid must be changed under the root_item_lock.
> > 
> > I think it should be fine to keep the transaction start where it is,
> > change the received_uuid eventually and let it commit. You can set the
> > transaction units to 2 unconditionally.
> 
> So what you are suggesting is to not move the transaction start before
> the if check? But then how would you structure the code to remove the
> uuid only if we are switchin RO->RW and not in send without duplicating
> the checks right before btrfs_update_root?

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1772,6 +1772,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
        u64 root_flags;
        u64 flags;
        int ret = 0;
+       bool clear_received_uuid = false;

        if (!inode_owner_or_capable(inode))
                return -EPERM;
@@ -1820,6 +1821,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
                        btrfs_set_root_flags(&root->root_item,
                                     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
                        spin_unlock(&root->root_item_lock);
+                       clear_received_uuid = true;
                } else {
                        spin_unlock(&root->root_item_lock);
                        btrfs_warn(fs_info,
@@ -1836,6 +1838,24 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
                goto out_reset;
        }

+       if (clear_received_uuid) {
+               if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
+                       ret = btrfs_uuid_tree_rem(trans, fs_info,
+                                       root->root_item.received_uuid,
+                                       BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+                                       root->root_key.objectid);
+
+                       if (ret && ret != -ENOENT) {
+                               btrfs_abort_transaction(trans, ret);
+                               btrfs_end_transaction(trans);
+                               goto out_reset;
+                       }
+
+                       memset(root->root_item.received_uuid, 0,
+                                       BTRFS_UUID_SIZE);
+               }
+       }
+
        ret = btrfs_update_root(trans, fs_info->tree_root,
                                &root->root_key, &root->root_item);


