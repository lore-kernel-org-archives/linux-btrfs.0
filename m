Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16832 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753710AbbK0BtU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 20:49:20 -0500
Subject: Re: btrfs: poor performance on deleting many large files
To: Mitchell Fossen <msfossen@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        <linux-btrfs@vger.kernel.org>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
 <1448488198.4717.4.camel@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5657B690.3080900@cn.fujitsu.com>
Date: Fri, 27 Nov 2015 09:49:04 +0800
MIME-Version: 1.0
In-Reply-To: <1448488198.4717.4.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mitchell Fossen wrote on 2015/11/25 15:49 -0600:
> On Mon, 2015-11-23 at 06:29 +0000, Duncan wrote:
>
>> Using subvolumes was the first recommendation I was going to make, too,
>> so you're on the right track. =:^)
>>
>> Also, in case you are using it (you didn't say, but this has been
>> demonstrated to solve similar issues for others so it's worth
>> mentioning), try turning btrfs quota functionality off.  While the devs
>> are working very hard on that feature for btrfs, the fact is that it's
>> simply still buggy and doesn't work reliably anyway, in addition to
>> triggering scaling issues before they'd otherwise occur.  So my
>> recommendation has been, and remains, unless you're working directly with
>> the devs to fix quota issues (in which case, thanks!), if you actually
>> NEED quota functionality, use a filesystem where it works reliably, while
>> if you don't, just turn it off and avoid the scaling and other issues
>> that currently still come with it.
>>
>
> I did indeed have quotas turned on for the home directories! Since they were
> mostly to calculate space used by everyone (since du -hs is so slow) and not
> actually needed to limit people, I disabled them.

[[About quota]]
Personally speaking, I'd like to have some comparison between quota 
enabled and disabled, to help locate if it's quota causing the problem.

If you can find a good and reliable reproducer, it would be very helpful 
for developers to improve btrfs.

BTW, it's also a good idea to us ps to locate what process is running at 
the time your btrfs hangs.

If it's kernel thread named btrfs-transaction, then it may be related to 
quota.


>
>> As for defrag, that's quite a topic of its own, with complications
>> related to snapshots and the nocow file attribute.  Very briefly, if you
>> haven't been running it regularly or using the autodefrag mount option by
>> default, chances are your available free space is rather fragmented as
>> well, and while defrag may help, it may not reduce fragmentation to the
>> degree you'd like.  (I'd suggest using filefrag to check fragmentation,
>> but it doesn't know how to deal with btrfs compression, and will report
>> heavy fragmentation for compressed files even if they're fine.  Since you
>> use compression, that kind of eliminates using filefrag to actually see
>> what your fragmentation is.)
>> Additionally, defrag isn't snapshot aware (they tried it for a few
>> kernels a couple years ago but it simply didn't scale), so if you're
>> using snapshots (as I believe Ubuntu does by default on btrfs, at least
>> taking snapshots for upgrade-in-place), so using defrag on files that
>> exist in the snapshots as well can dramatically increase space usage,
>> since defrag will break the reflinks to the snapshotted extents and
>> create new extents for defragged files.
>>
>> Meanwhile, the absolute worst-case fragmentation on btrfs occurs with
>> random-internal-rewrite-pattern files (as opposed to never changed, or
>> append-only).  Common examples are database files and VM images.  For
>> /relatively/ small files, to say 256 MiB, the autodefrag mount option is
>> a reasonably effective solution, but it tends to have scaling issues with
>> files over half a GiB so you can call this a negative recommendation for
>> trying that option with half-gig-plus internal-random-rewrite-pattern
>> files.  There are other mitigation strategies that can be used, but here
>> the subject gets complex so I'll not detail them.  Suffice it to say that
>> if the filesystem in question is used with large VM images or database
>> files and you haven't taken specific fragmentation avoidance measures,
>> that's very likely a good part of your problem right there, and you can
>> call this a hint that further research is called for.
>>
>> If your half-gig-plus files are mostly write-once, for example most media
>> files unless you're doing heavy media editing, however, then autodefrag
>> could be a good option in general, as it deals well with such files and
>> with random-internal-rewrite-pattern files under a quarter gig or so.  Be
>> aware, however, that if it's enabled on an already heavily fragmented
>> filesystem (as yours likely is), it's likely to actually make performance
>> worse until it gets things under control.  Your best bet in that case, if
>> you have spare devices available to do so, is probably to create a fresh
>> btrfs and consistently use autodefrag as you populate it from the
>> existing heavily fragmented btrfs.  That way, it'll never have a chance
>> for the fragmentation to build up in the first place, and autodefrag used
>> as a routine mount option should keep it from getting bad in normal use.
>
> Thanks for explaining that! Most of these files are written once and then read
> from for the rest of their "lifetime" until the simulations are done and they
> get archived/deleted. I'll try leaving autodefrag on and defragging directories
> over the holiday weekend when no one is using the server. There is some database
> usage, but I turned off COW for its folder and it only gets used sporadically
> and shouldn't be a huge factor in day-to-day usage.
>
> Also, is there a recommendation for relatime vs noatime mount options? I don't
> believe anything that runs on the server needs to use file access times, so if
> it can help with performance/disk usage I'm fine with setting it to noatime.
>
> I just tried copying a 70GB folder and then rm -rf it and it didn't appear to
> impact performance, and I plan to try some larger tests later.

It depends on the folder structure, but even for the worst case, it 
won't really trigger your problem.

[[About large files in btrfs]]
I agree with Duncan's suggestion completely, as that's the problem of 
btrfs fs tree design, it will cause too much race on the same tree lock.
Change it multi-subvolume will improve performance greatly especially 
for large files/directories.

The real problem is, btrfs delete one large file in a very unscaled method:

Block transaction until *all* the file extents belong to the inode are 
deleted.

Check __btrfs_update_delayed_inode() function in fs/btrfs/delayed-inode.c.

For small files that's OK, but for super huge files, that's a nightmare,
as the transaction won't be committed until all the file extents are 
deleted.
For 70G case, it will be consist of less than 600 file extents.
2 ~ 3 leaves can handle it, you may not feel the glitch when running 
delayed inode.

But for your 500~700G case, btrfs will need to delete about 4K file 
extents, the deletion may change the b-tree hugely, and takes a longer time.

So in your case, you may need that large files to trigger the problem...

We can try a better method to delete some file extents transcation by 
transaction, and hopes it may help your case.

Thanks,
Qu


>
> Thanks again for the help!
>
> -Mitch
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


