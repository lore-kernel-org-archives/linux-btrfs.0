Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33745 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbDHHRG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 03:17:06 -0400
Received: by paboj16 with SMTP id oj16so106049727pab.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 00:17:05 -0700 (PDT)
Date: Wed, 8 Apr 2015 00:17:03 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
Message-ID: <20150408071703.GA24891@mew>
References: <cover.1428471096.git.osandov@osandov.com>
 <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com>
 <5524C556.1040607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5524C556.1040607@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 08, 2015 at 02:06:14PM +0800, Qu Wenruo wrote:
> 
> 
> -------- Original Message  --------
> Subject: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
> From: Omar Sandoval <osandov@osandov.com>
> To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba
> <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
> Date: 2015年04月08日 13:34
> 
> >Currently, mounting a subvolume with subvolid= takes a different code
> >path than mounting with subvol=. This isn't really a big deal except for
> >the fact that mounts done with subvolid= or the default subvolume don't
> >have a dentry that's connected to the dentry tree like in the subvol=
> >case. To unify the code paths, when given subvolid= or using the default
> >subvolume ID, translate it into a subvolume name by walking
> >ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.

Hi, Qu,

> Oh, this patch is what I have tried long long ago, and want to do the same
> thing, to show subvolume mount for btrfs.

Thanks for pointing that out, I didn't come across your post when I was
looking around. I figured that someone must have thought of it first :) 

> But it came to me that, superblock->show_path() is a better method to do it.
> 
> You can implement btrfs_show_path() to allow mountinfo to get the subvolume
> name from subvolid, and don't change the mount routine much.

Hm, I don't think that the changes to the mount code would be
unwarranted. Having one code path makes it more obvious what's going on.
Do you mind elaborating on why you preferred doing it in ->show_path()?

Thanks!

> Thanks,
> Qu

-- 
Omar
