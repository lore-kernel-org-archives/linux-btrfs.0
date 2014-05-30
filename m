Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbaE3OKQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 10:10:16 -0400
Date: Fri, 30 May 2014 16:10:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 1/4] btrfs: dev delete should remove sysfs entry
Message-ID: <20140530141014.GG29992@suse.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-2-git-send-email-anand.jain@oracle.com>
 <20140529130428.GC29992@twin.jikos.cz>
 <538820D4.3010808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538820D4.3010808@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 30, 2014 at 02:10:28PM +0800, Anand Jain wrote:
> >>@@ -572,6 +572,26 @@ static void init_feature_attrs(void)
> >>  	}
> >>  }
> >>
> >>+int rm_device_membership(struct btrfs_fs_info *fs_info,
> >>+		struct btrfs_device *one_device)
> >
> >The name is too generic for a non-static function, so it would be good
> >to add at least the btrfs_ prefix. Same applies to the change of
> >'add_device_membership' in the next patch.
> 
>  Yes indeed. I wanted it to change as well. But the diff became
>  unfriendly to read.  I shall do that in a separate patch.

No problem with doing the rename changes in a separate patch, but here
you introduce a new function, that should get the right name from the
beginning. If this would look inconsitent with the add_ counterpart,
then do the rename of add_ in advance.
