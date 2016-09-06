Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34724 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbcIFVxw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 17:53:52 -0400
Received: by mail-wm0-f50.google.com with SMTP id w207so36849756wmw.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 14:53:52 -0700 (PDT)
Subject: Re: btrfs send extremely slow (almost stuck)
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
 <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
 <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
 <2ae7659b-ebb2-200b-174e-9ca186cb22cd@cn.fujitsu.com>
 <22d296fa-7673-780a-0171-d87f2d7bbce6@googlemail.com>
 <d42a9f0a-5e30-3977-f74e-eece05308537@cn.fujitsu.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <5ef3f999-c714-bb03-aca7-719aff0d39a7@googlemail.com>
Date: Tue, 6 Sep 2016 23:53:49 +0200
MIME-Version: 1.0
In-Reply-To: <d42a9f0a-5e30-3977-f74e-eece05308537@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 06.09.2016 um 04:46 schrieb Qu Wenruo:
> But your idea to locate the inode seems good enough for debugging though.

Based on this I even had another idea which seems to have worked well - and I am now also able to provide any additional debug output you may need. 


Since my procedure may be interesting / helpful for other "debugging users", I'll shortly outline it here. 
I had enough extra space on an external HDD. I cloned the full btrfs partition with 'dd' to an image on this HDD.
I loop'ed that image read-only on another machine, created an overlay-file and used device mapper
to get a read-write block device for any experiment (based on the read-only image).
Details on that e.g. at https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file . 


> In this case, before reverting to a backup, would you please run a "btrfsck check" and paste the output?

Now, I ran 'btrfs check' on that device. I'm using the very fresh btrfs-progs 4.7.2. 
The output is here:
http://pastebin.com/rMrW40RU
Notably, it claims to have found some other issues, mainly wrong link counts and dir isizes, but for various inodes...

Now, I could also safely run 'btrfs check --repair' on this device without any risks.
The output from that is here:
http://pastebin.com/XW9ChuqU

Another 'btrfs check' run afterwards now reveals different issues:
http://pastebin.com/TFKJa81e

Now, another repair:
http://pastebin.com/33iqaE9E

Now, finally, btrfs check is happy:
http://pastebin.com/izkERtKp

After mounting, finally (kernel 4.7.2) I see in kernel log:
[12108.696912] BTRFS info (device dm-0): disk space caching is enabled
[12108.713176] BTRFS info (device dm-0): checking UUID tree

I can now delete the "broken" .thunderbird folder on this "repaired" fs.
I can also mount it and write data on it.

Concluding from these results that it should be safe to do the same to my original block device with the same btrfs-progs version
I did just that (check, repair, check, repair, check) from a live system directly on the machine. 
Up until now, the FS seems to be doing well again - I took the chance to enable skinny extents and am now doing a full metadata balance,
saving me about 0.25 % of metadata space. 
So finally, first time in my life, 'btrfs check --repair' did not eat my data! :-) 


The cool thing is that now I still have the broken image (extracted with dd) around and can play with it to provide you with any debug-info
without having to work directly with the broken FS on the machine itself. 


Now, let's get started on that.

ls -aldi .thunderbird-broken/p6bm45oa.default/
162786 drwx------ 1 olifre olifre 2482  5. Sep 23:07 .thunderbird-broken/p6bm45oa.default/
As you can see, I had renamed .thunderbird to .thunderbird-broken. The real issue is in any case the profile-subfolder within.
So the affected ino is indeed 162786 which also shows up (as one of several issues...) in the btrfs check (and repair) output.

> Further more, your btrfs-debug-tree dump should provide more help for this case.

Just to make sure the debug-tree output matches the rest of all the information I'm giving you, I re-ran that on the dd'ed image from the broken FS like so:
btrfs-debug-tree -t 442 xmg13.img | sed "s/name:.*//" > debug-tree

I ran the output through xz (or rather, pixz) and here it is:
https://cernbox.cern.ch/index.php/s/imjwqsOFerUklqr/download
I'll probably not keep the file up there forever, but at least for quite some days.

If you can think of any other information which may be useful to diagnose the underlying issue which caused that corruption
just let me know. I'll keep the image of the broken FS around for a few weeks.

Cheers, 
	Oliver
