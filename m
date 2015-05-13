Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35116 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbbEMRqL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 13:46:11 -0400
Received: by qgej70 with SMTP id j70so25376737qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 10:46:10 -0700 (PDT)
Message-ID: <1431539167.9076.9.camel@kepstin.ca>
Subject: Re: shall I use BTRFS sub-volumes for top-level directories ?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 13 May 2015 13:46:07 -0400
In-Reply-To: <55535C12.3010807@gmx.de>
References: <55535C12.3010807@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2015-05-13 at 16:13 +0200, Toralf Förster wrote:
> To support the Gentoo Linux ecosystem I do maintain a server as a 
> tinderbox. I create chroot images based on various Gentoo minmal ISO 
> images. I usually run 4 chroot image jobs in parallel. The chroots 
> are full-filled over days/weeks with the compiled output. Issues 
> during that are filed into Gentoo's bugzilla.
> 
> If an image is "full" (~35 GB with many files + directories in it) 
> or completely bricked I create a new one of the same type. The old 
> is kept for weeks/months to further serve to bug reports questions. 
> But old images are rarely accessed usually.
> 
> Because deleting a chroot image takes awfully long and b/c I 
> experience iowait spikes even if the 3 TB drive isn't filled by more 
> than 50% I do wonder, if it would make sense to create a btrfs 
> subvolume for each chroot image ?
> The deletion of a subvolume should be fast compared to recursivly 
> deleting a 35 GB file system structure, right ?

Unfortunately, this isn't entirely the case… Deleting a subvolume 
actually triggers a background garbage-collecting thread to run in the 
kernel (named "btrfs-cleaner") which goes recursively through the 
deleted tree to unallocate the files.

It will probably save a bit of IO compared to doing it with "rm -r", 
because there is less metadata updating. (You'll probably see that the 
"btrfs-transaction" process has high disk io during "rm -r", since it 
has to commit metadata periodically while the delete is still in 
progress.)

Unfortunately the IO scheduling on btrfs-cleaner currently isn't 
great, so it'll likely still cause io spikes, reducing performance of 
other applications while it runs.

As with all things, it's probably best if you just try it and see!

> (And BTW what's about re-balancing of the BTRFS-tree during the 
> daily usage: wouldn't this profit from that too ?

All subvolumes share the same allocated space for metadata and data, 
so using subvolumes vs. directories currently won't make any 
difference regarding rebalancing.

-- 
Calvin Walton <calvin.walton@kepstin.ca>
