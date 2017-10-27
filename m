Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44889 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932384AbdJ0UK4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 16:10:56 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Data and metadata extent allocators [1/2]: Recap: The data story
Date: Fri, 27 Oct 2017 22:10:54 +0200
Message-ID: <1833040.vtX8kJ14V9@merkaba>
In-Reply-To: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hans,

Hans van Kranenburg - 27.10.17, 20:17:
> This is a followup to my previous threads named "About free space
> fragmentation, metadata write amplification and (no)ssd" [0] and
> "Experiences with metadata balance/convert" [1], exploring how good or
> bad btrfs can handle filesystems that are larger than your average
> desktop computer and/or which see a pattern of writing and deleting huge
> amounts of files of wildly varying sizes all the time.
[…]
> Q: How do I fight this and prevent getting into a situation where all
> raw space is allocated, risking a filesystem crash?
> A: Use btrfs balance to fight the symptoms. It reads data and writes it
> out again without the free space fragments.

What do you mean by a filesystem crash? Since kernel 4.5 or 4.6 I don´t see any 
BTRFS related filesystem hangs anymore on the /home BTRFS Dual SSD RAID 1 on my 
Laptop, which one or two copies of Akonadi, Baloo and other desktop related 
stuff write *heavily to* and which has all free space allocated into cunks 
since a pretty long time:

merkaba:~> btrfs fi usage -T /home
Overall:
    Device size:                 340.00GiB
    Device allocated:            340.00GiB
    Device unallocated:            2.00MiB
    Device missing:                  0.00B
    Used:                        290.32GiB
    Free (estimated):             23.09GiB      (min: 23.09GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

                          Data      Metadata System              
Id Path                   RAID1     RAID1    RAID1    Unallocated
-- ---------------------- --------- -------- -------- -----------
 1 /dev/mapper/msata-home 163.94GiB  6.03GiB 32.00MiB     1.00MiB
 2 /dev/mapper/sata-home  163.94GiB  6.03GiB 32.00MiB     1.00MiB
-- ---------------------- --------- -------- -------- -----------
   Total                  163.94GiB  6.03GiB 32.00MiB     2.00MiB
   Used                   140.85GiB  4.31GiB 48.00KiB

I didn´t do a balance on this filesystem since a long time (kernel 4.6).

Granted my filesystem is smaller than the typical backup BTRFS. I do have two 3 
TB and one 1,5 TB SATA disks I backup to and another 2 TB BTRFS on a backup 
server that I use for borgbackup (and that doesn´t yet do any snapshots and 
may be better of running as XFS as it doesn´t really need snapshots as 
borgbackup takes care of that. A BTRFS snapshot would only come handy to be 
able to go back to a previous borgbackup repo in case it for whatever reason 
gets corrupted or damaged / deleted by an attacker who only access to non 
privileged user). – However all of these filesystems have plenty of free space 
currently and are not accessed daily.

> Q: Why would it crash the file system when all raw space is allocated?
> Won't it start trying harder to reuse the free space inside?
> A: Yes, it will, for data. The big problem here is that allocation of a
> new metadata chunk when needed is not possible any more.

And there it hangs or really crashes?

[…]

> Q: Why do the pictures of my data block groups look like someone fired a
> shotgun at it. [3], [4]?
> A: Because the data extent allocator that is active when using the 'ssd'
> mount option both tends to ignore smaller free space fragments all the
> time, and also behaves in a way that causes more of them to appear. [5]
> 
> Q: Wait, why is there "ssd" in my mount options? Why does btrfs think my
> iSCSI attached lun is an SSD?
> A: Because it makes wrong assumptions based on the rotational attribute,
> which we can also see in sysfs.
> 
> Q: Why does this ssd mode ignore free space?
> A: Because it makes assumptions about the mapping of the addresses of
> the block device we see in linux and the storage in actual flash chips
> inside the ssd. Based on that information it decides where to write or
> where not to write any more.
> 
> Q: Does this make sense in 2017?
> A: No. The interesting relevant optimization when writing to an ssd
> would be to write all data together that will be deleted or overwritten
> together at the same time in the future. Since btrfs does not come with
> a time machine included, it can't do this. So, remove this behaviour
> instead. [6]
> 
> Q: What will happen when I use kernel 4.14 with the previously mentioned
> change, or if I change to the nossd mount option explicitely already?
> A: Relatively small free space fragments in existing chunks will
> actually be reused for new writes that fit, working from the beginning
> of the virtual address space upwards. It's like tetris, trying to
> completely fill up the lowest lines first. See the big difference in
> behavior when changing extent allocator happening at 16 seconds into
> this timelapse movie: [7] (virtual address space)

I see a difference in behavior but I do not yet fully understand what I am 
looking at.
 
> Q: But what if all my chunks have badly fragmented free space right now?
> A: If your situation allows for it, the simplest way is running a full
> balance of the data, as some sort of big reset button. If you only want
> to clean up chunks with excessive free space fragmentation, then you can
> use the helper I used to identify them, which is
> show_free_space_fragmentation.py in [8]. Just feed the chunks to balance
> starting with the one with the highest score. The script requires the
> free space tree to be used, which is a good idea anyway.

Okay, when I understand this correctly I don´t need to use "nossd" with kernel 
4.14, but it would be good to do a full "btrfs filesystem balance" run on all 
the SSD BTRFS filesystems or all other ones with rotational=0.

What would be the benefit of that? Would the filesystem run faster again? My 
subjective impression is that performance got worse over time. *However* all 
my previous full balance attempts made the performance even more worse. So… is 
a full balance safe to the filesystem performance meanwhile?

I still have the issue that fstrim on /home only works with patch from Lutz 
Euler from 2014, which is still not in mainline BTRFS. Maybe it would be a 
good idea to recreate /home in order to get rid of that special "anomaly" of 
the BTRFS that fstrim don´t work without this patch.

Maybe a least a part of this should go into BTRFS kernel wiki as it would be 
more easy to find there for users.

I wonder about a "upgrade notes for users" / "BTRFS maintenance" page that 
gives recommendations in case some step is recommended after a major kernel 
update and general recommendations for maintenance. Ideally most of this would 
be integrated into BTRFS or a userspace daemon for it and be handled 
transparently and automatically. Yet a full balance is an expensive operation 
time-wise and probably should not be started without user consent.

I do wonder about the ton of tools here and there and I would love some btrfsd 
or… maybe even more generic fsd filesystem maintenance daemon which would do 
regular scrubs and whatever else makes sense. It could use some configuration 
in the root directory of a filesystem and work for BTRFS and other filesystem 
that do have beneficial online / background upgraded like XFS which also has 
online scrubbing by now (at least for metadata).

> [0] https://www.spinics.net/lists/linux-btrfs/msg64446.html
> [1] https://www.spinics.net/lists/linux-btrfs/msg64771.html
> [2] https://github.com/knorrie/btrfs-heatmap/
> [3]
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-10-27-shotgunblast.png
> [4]
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2016-12-18-heatmap-scripting/
> fsid_ed10a358-c846-4e76-a071-3821d423a99d_startat_320029589504_at_1482095269
> .png [5] https://www.spinics.net/lists/linux-btrfs/msg64418.html
> [6]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?i
> d=583b723151794e2ff1691f1510b4e43710293875 [7]
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-ssd-to-nossd.mp4 [8]
> https://github.com/knorrie/python-btrfs/tree/develop/examples

Thanks,
-- 
Martin
