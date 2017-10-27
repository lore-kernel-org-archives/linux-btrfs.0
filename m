Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33436 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdJ0SR6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 14:17:58 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id C0933584AB7C
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 20:17:56 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Data and metadata extent allocators [1/2]: Recap: The data story
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
Date: Fri, 27 Oct 2017 20:17:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This is a followup to my previous threads named "About free space
fragmentation, metadata write amplification and (no)ssd" [0] and
"Experiences with metadata balance/convert" [1], exploring how good or
bad btrfs can handle filesystems that are larger than your average
desktop computer and/or which see a pattern of writing and deleting huge
amounts of files of wildly varying sizes all the time.

This message is a summary of the earlier posts. So, for whoever followed
the story, only boring old news here. In the next message as a reply on
this one, I'll add some thoughts about new adventures with metadata
during the last weeks.

My use case is using btrfs as filesystem for backup servers, which work
with collections of subvolumes/snapshots with related data, and add new
data and expire old snapshots daily.

Until now, the following questions were already answered:

Q: Why does the allocated but unused space for data keep growing all the
time?
A: Because btrfs keeps allocating new raw space for data use, while
there's more and more unused space inside already which isn't reused for
new data.

Q: How do I fight this and prevent getting into a situation where all
raw space is allocated, risking a filesystem crash?
A: Use btrfs balance to fight the symptoms. It reads data and writes it
out again without the free space fragments.

Q: Why would it crash the file system when all raw space is allocated?
Won't it start trying harder to reuse the free space inside?
A: Yes, it will, for data. The big problem here is that allocation of a
new metadata chunk when needed is not possible any more.

Q: Where does btrfs balance get the usage information from (what %
filled a chunk / block group is)? How can I see this myself?
A: It's a field of the "block group" item in metadata. The information
can be read from the filesystem metadata using the tree search ioctl.
Exploring this resulted in the first version of btrfs-heatmap. [2]

Q: Ok, but I have many TiBs of data chunks which are ~75% filled and
rewriting all that data is painful, takes a huge amount of time and even
if I would do it full-time aside from doing backups and expiries, I
won't succeed in fighting new fragmented free space that pops up. Help!
A: Yeah, we need something better.

Q: How can I see what the pattern is of free space fragments in a block
group?
A: For this, extent level pictures in btrfs-heatmap were added. [2]

Q: Why do the pictures of my data block groups look like someone fired a
shotgun at it. [3], [4]?
A: Because the data extent allocator that is active when using the 'ssd'
mount option both tends to ignore smaller free space fragments all the
time, and also behaves in a way that causes more of them to appear. [5]

Q: Wait, why is there "ssd" in my mount options? Why does btrfs think my
iSCSI attached lun is an SSD?
A: Because it makes wrong assumptions based on the rotational attribute,
which we can also see in sysfs.

Q: Why does this ssd mode ignore free space?
A: Because it makes assumptions about the mapping of the addresses of
the block device we see in linux and the storage in actual flash chips
inside the ssd. Based on that information it decides where to write or
where not to write any more.

Q: Does this make sense in 2017?
A: No. The interesting relevant optimization when writing to an ssd
would be to write all data together that will be deleted or overwritten
together at the same time in the future. Since btrfs does not come with
a time machine included, it can't do this. So, remove this behaviour
instead. [6]

Q: What will happen when I use kernel 4.14 with the previously mentioned
change, or if I change to the nossd mount option explicitely already?
A: Relatively small free space fragments in existing chunks will
actually be reused for new writes that fit, working from the beginning
of the virtual address space upwards. It's like tetris, trying to
completely fill up the lowest lines first. See the big difference in
behavior when changing extent allocator happening at 16 seconds into
this timelapse movie: [7] (virtual address space)

Q: But what if all my chunks have badly fragmented free space right now?
A: If your situation allows for it, the simplest way is running a full
balance of the data, as some sort of big reset button. If you only want
to clean up chunks with excessive free space fragmentation, then you can
use the helper I used to identify them, which is
show_free_space_fragmentation.py in [8]. Just feed the chunks to balance
starting with the one with the highest score. The script requires the
free space tree to be used, which is a good idea anyway.

[0] https://www.spinics.net/lists/linux-btrfs/msg64446.html
[1] https://www.spinics.net/lists/linux-btrfs/msg64771.html
[2] https://github.com/knorrie/btrfs-heatmap/
[3]
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-10-27-shotgunblast.png
[4]
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2016-12-18-heatmap-scripting/fsid_ed10a358-c846-4e76-a071-3821d423a99d_startat_320029589504_at_1482095269.png
[5] https://www.spinics.net/lists/linux-btrfs/msg64418.html
[6]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=583b723151794e2ff1691f1510b4e43710293875
[7] https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-ssd-to-nossd.mp4
[8] https://github.com/knorrie/python-btrfs/tree/develop/examples

-- 
Hans van Kranenburg
