Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52370 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbeGBTkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 15:40:20 -0400
Date: Mon, 2 Jul 2018 12:40:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: how to best segment a big block device in resizeable btrfs filesystems?
Message-ID: <20180702194015.GC9859@merlins.org>
References: <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <20180702151853.mwlrinipbihq46zu@merlins.org> <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com> <20180702173438.7c2vhflvtncfb5gz@merlins.org> <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 02:35:19PM -0400, Austin S. Hemmelgarn wrote:
> >I kind of linked the thin provisioning idea because it's hands off,
> >which is appealing. Any reason against it?
> No, not currently, except that it adds a whole lot more stuff between 
> BTRFS and whatever layer is below it.  That increase in what's being 
> done adds some overhead (it's noticeable on 7200 RPM consumer SATA 
> drives, but not on decent consumer SATA SSD's).
> 
> There used to be issues running BTRFS on top of LVM thin targets which 
> had zero mode turned off, but AFAIK, all of those problems were fixed 
> long ago (before 4.0).

I see, thanks for the heads up.

> >Does LVM do built in raid5 now? Is it as good/trustworthy as mdadm
> >radi5?
> Actually, it uses MD's RAID5 implementation as a back-end.  Same for 
> RAID6, and optionally for RAID0, RAID1, and RAID10.
 
Ok, that makes me feel a bit better :)

> >But yeah, if it's incompatible with thin provisioning, it's not that
> >useful.
> It's technically not incompatible, just a bit of a pain.  Last time I 
> tried to use it, you had to jump through hoops to repair a damaged RAID 
> volume that was serving as an underlying volume in a thin pool, and it 
> required keeping the thin pool offline for the entire duration of the 
> rebuild.

Argh, not good :( / thanks for the heads up.

> If you do go with thin provisioning, I would encourage you to make 
> certain to call fstrim on the BTRFS volumes on a semi regular basis so 
> that the thin pool doesn't get filled up with old unused blocks, 

That's a very good point/reminder, thanks for that. I guess it's like
running on an ssd :)

> preferably when you are 100% certain that there are no ongoing writes on 
> them (trimming blocks on BTRFS gets rid of old root trees, so it's a bit 
> dangerous to do it while writes are happening).
 
Argh, that will be harder, but I'll try.

Given what you said, it sounds like I'll still be best off with separate
layers to avoid the rebuild problem you mentioned.
So it'll be
swraid5 / dmcrypt / bcache / lvm dm thin / btrfs

Hopefully that will work well enough.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
