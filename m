Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34889 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbcFWXhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 19:37:11 -0400
Received: by mail-oi0-f54.google.com with SMTP id r2so93507218oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 16:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
References: <20160620034427.GK15597@hungrycats.org> <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org> <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Jun 2016 17:37:09 -0600
Message-ID: <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 11:14 AM, Chris Murphy <lists@colorremedies.com> wrote:

>
> However, from btrfs-debug-tree from a 3 device raid5 volume:
>
> item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 15621 itemsize 144
> chunk length 2147483648 owner 2 stripe_len 65536
> type DATA|RAID5 num_stripes 3
> stripe 0 devid 2 offset 9437184
> dev uuid: 3c6f37eb-5cae-455a-82bc-a1b0877dea55
> stripe 1 devid 1 offset 1094713344
> dev uuid: 13104709-6f30-4982-979e-4f055c326fad
> stripe 2 devid 3 offset 1083179008
> dev uuid: d45fc482-a0c1-46b1-98c1-41cea5a11c80
>
> I expect that parity is in this data block group, and therefore is
> checksummed the same as any other data in that block group.

This appears to be wrong. Comparing the same file, one file only, one
two new Btrfs volumes, one volume single, one volume raid5, I get a
single csum tree entry:

raid5
    item 0 key (EXTENT_CSUM EXTENT_CSUM 12009865216) itemoff 16155 itemsize 128
        extent csum item

single

    item 0 key (EXTENT_CSUM EXTENT_CSUM 2168717312) itemoff 16155 itemsize 128
        extent csum item

They're both the same size. They both contain the same data. So it
looks like parity is not separately checksummed.

If there's a missing 64KiB data strip (bad sector, or dead drive), the
reconstruction of that strip from parity should match available csums
for those blocks. So in this way it's possible to infer if the parity
strip is bad. But, it also means assuming everything else about this
full stripe: the remaining data strips and their csums, are correct.




> So in your example of degraded writes, no matter what the on disk
> format makes it discoverable there is a problem:
>
> A. The "updating" is still always COW so there is no overwriting.

There is RMW code in btrfs/raid56.c but I don't know when that gets
triggered. With simple files changing one character with vi and gedit,
I get completely different logical and physical numbers with each
change, so it's clearly cowing the entire stripe (192KiB in my 3 dev
raid5).


[root@f24s ~]# filefrag -v /mnt/5/64k-a-then64k-b.txt
Filesystem type is: 9123683e
File size of /mnt/5/64k-a-then64k-b.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    2931744..   2931775:     32:             last,eof
/mnt/5/64k-a-then64k-b.txt: 1 extent found
[root@f24s ~]# btrfs-map-logical -l $[4096*2931744] /dev/VG/a
mirror 1 logical 12008423424 physical 1114112 device /dev/mapper/VG-b
mirror 2 logical 12008423424 physical 34668544 device /dev/mapper/VG-a
[root@f24s ~]# vi /mnt/5/64k-a-then64k-b.txt
[root@f24s ~]# filefrag -v /mnt/5/64k-a-then64k-b.txt
Filesystem type is: 9123683e
File size of /mnt/5/64k-a-then64k-b.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    2931776..   2931807:     32:             last,eof
/mnt/5/64k-a-then64k-b.txt: 1 extent found
[root@f24s ~]# btrfs-map-logical -l $[4096*29317776] /dev/VG/a
No extent found at range [120085610496,120085626880)
[root@f24s ~]# btrfs-map-logical -l $[4096*2931776] /dev/VG/a
mirror 1 logical 12008554496 physical 1108475904 device /dev/mapper/VG-c
mirror 2 logical 12008554496 physical 1179648 device /dev/mapper/VG-b
[root@f24s ~]#

There is a neat bug/rfe I found for btrfs-map-logical, it doesn't
report back the physical locations for all num_stripes on the volume.
It only spits back two, and sometimes it's the two data strips,
sometimes it's one data and one parity strip.


[1]
https://bugzilla.kernel.org/show_bug.cgi?id=120941


-- 
Chris Murphy
