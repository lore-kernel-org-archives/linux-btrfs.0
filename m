Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaEWOcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 10:32:48 -0400
Date: Fri, 23 May 2014 16:32:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
Message-ID: <20140523143246.GF5346@suse.cz>
Reply-To: dsterba@suse.cz
References: <537D40EB.60906@fb.com>
 <537D5136.4050007@suse.com>
 <537DEB3F.5020303@fb.com>
 <537E1242.1010109@suse.com>
 <537E313E.8050906@fb.com>
 <20140523123849.GE5346@suse.cz>
 <537F4566.2000907@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537F4566.2000907@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 23, 2014 at 08:56:06AM -0400, Jeff Mahoney wrote:
> Sigh. Yep. kobject_cleanup caches ->name before the release function
> and ignores the cleared value. It seems the "free name if we alloced
> it" comment in there was leftover from the middle of a patch series
> Kay applied in late 2007. Commit 0f4dafc05 adds the comment while
> adding a flag to indicate that kobject_set_name_vargs set the name.
> The commit af5ca3f4e says kobject names must be dynamic but didn't
> update the comment.
> 
> Ok, so we can't save the strdup.

The tests have been running fine for more than 40 minutes, previously it
took a few minutes to trigger the bug.

my quick fix:

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8354,7 +8354,8 @@ static void __link_block_group(struct btrfs_space_info *space_info,
                int ret;

                kobject_get(&space_info->kobj); /* put in release */
-               kobj->name = get_raid_name(index);
+               kobj->name = kstrdup(get_raid_name(index), GFP_ATOMIC);
+               BUG_ON(!kobj->name);
                ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
                                           &space_info->kobj, NULL);
                if (ret) {
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d742d7973d3e..ac26f91968a7 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -288,7 +288,7 @@ static struct attribute *raid_attributes[] = {

 static void release_raid_kobj(struct kobject *kobj)
 {
-       kobj->name = NULL;
+       /* kobj->name = NULL; */
        kobject_put(kobj->parent);
 }

