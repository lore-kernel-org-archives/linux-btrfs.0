Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48346 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbeGJEBA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 00:01:00 -0400
Date: Mon, 9 Jul 2018 21:00:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Su Yue <Damenly_Su@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <20180710040055.tdswndw5wxclijns@merlins.org>
References: <f9bc21d6-fdc3-ca3a-793f-6fe574c7b8c6@cn.fujitsu.com>
 <20180709031054.qfg4x5yzcl4rao2k@merlins.org>
 <20180709031501.iutlokfvodtkkfhe@merlins.org>
 <17cc0cc1-b64d-4daa-18b5-bb2da3736ea1@cn.fujitsu.com>
 <20180709034058.wjavwjdyixx6smbw@merlins.org>
 <29302c14-e277-2c69-ac08-c4722c2b18aa@cn.fujitsu.com>
 <20180709155306.zr3p2kolnanvkpny@merlins.org>
 <trinity-4aae1c42-a85e-4c73-a30e-8b0d0be05e86-1531152875875@msvc-mesg-gmx023>
 <20180709174818.wq2d4awmgasxgwad@merlins.org>
 <faba0923-8d1f-5270-ba03-ce9cc484e08a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <faba0923-8d1f-5270-ba03-ce9cc484e08a@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To fill in for the spectators on the list :)
Su gave me a modified version of btrfsck lowmem that was able to clean
most of my filesystem.
It's not a general case solution since it had some hardcoding specific
to my filesystem problems, but still a great success.
Email quoted below, along with responses to Qu

On Tue, Jul 10, 2018 at 09:09:33AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月10日 01:48, Marc MERLIN wrote:
> > Success!
> > Well done Su, this is a huge improvement to the lowmem code. It went from days to less than 3 hours.
> 
> Awesome work!
> 
> > I'll paste the logs below.
> > 
> > Questions:
> > 1) I assume I first need to delete a lot of snapshots. What is the limit in your opinion?
> > 100? 150? other?
> 
> My personal recommendation is just 20. Not 150, not even 100.
 
I see. Then, I may be forced to recreate multiple filesystems anyway.
I have about 25 btrfs send/receive relationships and I have around 10
historical snapshots for each.

In the future, can't we segment extents/snapshots per subvolume, making
subvolumes mini filesystems within the bigger filesystem?

> But snapshot deletion will take time (and it's delayed, you won't know
> if something wrong happened just after "btrfs subv delete") and even
> require a healthy extent tree.
> If all extent tree errors are just false alert, that should not be a big
> problem at all.
> 
> > 
> > 2) my filesystem is somewhat misbalanced. Which balance options do you think are safe to use?
> 
> I would recommend to manually check extent tree for BLOCK_GROUP_ITEM,
> which will tell how big a block group is and how many space is used.
> And gives you an idea on which block group can be relocated.
> Then use vrange= to specify exact block group to relocation.
> 
> One example would be:
> 
> # btrfs ins dump-tree -t extent <dev> | grep -A1 BLOCK_GROUP_ITEM |\
>   tee block_group_dump
> 
> Then the output contains:
> 	item 1 key (13631488 BLOCK_GROUP_ITEM 8388608) itemoff 16206 itemsize 24
> 		block group used 262144 chunk_objectid 256 flags DATA
> 
> The "13631488" is the bytenr of the block group.
> The "8388608" is the length of the block group.
> The "262144" is the used bytes of the block group.
> 
> The less used space the higher priority it should be relocated. (and
> faster to relocate).
> You could write a small script to do it, or there should be some tool to
> do the calculation for you.
 
I usually use something simpler:
Label: 'btrfs_boot'  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
	Total devices 1 FS bytes used 30.19GiB
	devid    1 size 79.93GiB used 78.01GiB path /dev/mapper/cryptroot

This is bad, I have 30GB of data, but 78 out of 80GB of structures full.
This is bad news and recommends a balance, correct?
If so, I always struggle as to what value I should give to dusage and
musage...

> And only relocate one block group each time, to avoid possible problem.
> 
> The last but not the least, it's highly recommend to do the relocation
> only after unused snapshots are completely deleted.
> (Or it would be super super slow to relocate)

Thank you for the advise. Hopefully this hepls someone else too, and
maybe someone can write some reallocate helper tool if I don't have the
time to do it myself.

> > 3) Should I start a scrub now (takes about 1 day) or anything else to
> > check that the filesystem is hopefully not damaged anymore?
> 
> I would normally recommend to use btrfs check, but neither mode really
> works here.
> And scrub only checks csum, doesn't check the internal cross reference
> (like content of extent tree).
> 
> Maybe Su could skip the whole extent tree check and let lowmem to check
> the fs tree only, with --check-data-csum it should be a better work than
>  scrub.

I will wait to hear back from Su, but I think the current situation is
that I still have some problems on my FS, they are just
1) not important enough to block mount rw (now it works again)
2) currently ignored by the modified btrfsck I have, but would cause
problems if I used real btrfsck.

Correct?

> > 
> > 4) should btrfs check reset the corrupt counter?
> > bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> > for now, should I reset it manually?
> 
> It could be pretty easy to implement if not already implemented.

Seems like it's not given that Su's btrfsck --repair ran to completion
and I still have corrupt set to '2' :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
