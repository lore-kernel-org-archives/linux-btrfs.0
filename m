Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11959 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751350AbdK1IaD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 03:30:03 -0500
Date: Tue, 28 Nov 2017 16:29:01 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
Message-ID: <20171128082901.GE29491@fnst.localdomain>
References: <20171127094156.GC29491@fnst.localdomain>
 <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 27, 2017 at 06:13:10PM +0800, Qu Wenruo wrote:
>
>
>On 2017年11月27日 17:41, Lu Fengqi wrote:
>> Hi all,
>> 
>> As we all know, under certain circumstances, it is more appropriate to
>> create some subvolumes rather than keep everything in the same
>> subvolume. As the condition of demand change, the user may need to
>> convert a previous directory to a subvolume. For this reason，how about
>> adding an ioctl to convert a directory to a subvolume?
>
>The idea seems interesting.
>
>However in my opinion, this can be done quite easily in (mostly) user
>space, thanks to btrfs support of relink.
>
>The method from Hugo or Chris is quite good, maybe it can be enhanced a
>little.
>
>Use the following layout as an example:
>
>root_subv
>|- subvolume_1
>|  |- dir_1
>|  |  |- file_1
>|  |  |- file_2
>|  |- dir_2
>|     |- file_3
>|- subvolume_2
>
>If we want to convert dir_1 into subvolume, we can do it like:
>
>1) Create a temporary readonly snapshot of parent subvolume containing
>   the desired dir
>   # btrfs sub snapshot -r root_subv/subvolume_1 \
>     root_subv/tmp_snapshot_1
>
>2) Create a new subvolume, as destination.
>   # btrfs sub create root_subv/tmp_dest/
>
>3) Copy the content and sync the fs
>   Use of reflink is necessary.
>   # cp -r --reflink=always root_subv/tmp_snapshot_1/dir_1 \
>     root_subv/tmp_dest
>   # btrfs sync root_subv/tmp_dest
>
>4) Delete temporary readonly snapshot
>   # btrfs subvolume delete root_subv/tmp_snapshot_1
>
>5) Remove the source dir
>   # rm -rf root_subv/subvolume_1/dir_1
>
>5) Create a final destination snapshot of "root_subv/temporary_dest"
>   # btrfs subvolume snapshot root_subv/tmp_dest \
>     root_subv/subvolume_1/dir_1
>
>6) Remove the temporary destination
>   # btrfs subvolume delete root_subv/tmp_dest
>
>
>The main challenge is in step 3).
>In fact above method can only handle normal dir/files.
>If there is another subvolume inside the desired dir, current "cp -r" is
>a bad idea.
>We need to skip subvolume dir, and create snapshot for it.
>
>But it's quite easy to write a user space program to handle it.
>Maybe using "find" command can already handle it well.
>
>Anyway, doing it in user space is already possible and much easier than
>doing it in kernel.
>
>> 
>> Users can convert by the scripts mentioned in this
>> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is
>> it easier to use the off-the-shelf btrfs subcommand?
>
>If you just want to integrate the functionality into btrfs-progs, maybe
>it's possible.
>
>But if you insist in providing a new ioctl for this, I highly doubt if
>the extra hassle is worthy.
>

Thanks for getting back to me.

The enhanced approach you provide is pretty good, and I agree that it
meets the needs of some users.

>> 
>> After an initial consideration, our implementation is broadly divided
>> into the following steps:
>> 1. Freeze the filesystem or set the subvolume above the source directory
>> to read-only;
>
>Not really need to freeze the whole fs.
>Just create a readonly snapshot of the parent subvolume which contains
>the dir.
>That's how snapshot is designed for.
>

I still worry about the following problem. Although tmp_snapshot_1 is
read-only, the source directory dir_1 is still writable. Also, step 5)
will delete dir_1, which may result in the loss of newly written data
during the conversion.

I can not think of any method else for now, except I set the subvolume_1
read-only(obviously this is a bad idea). Could you provide some
suggestions?

>> 2. Perform a pre-check, for example, check if a cross-device link
>> creation during the conversion;
>
>This can be done in-the-fly.
>As the check is so easy (only needs to check if the inode number is 256).
>We only need a mid-order iteration of the source dir (in temporary
>snapshot), and for normal file, use reflink.
>For subvolume dir, create a snapshot for it.
>
>And for such iteration, a python script less than 100 lines would be
>sufficient.

Just to clarify, the check is to confirm if there is a hard link across
dir_1. The dir_1 can't be converted to subvolume if there is such a
cross-device link that can not be created.

>
>Thanks,
>Qu
>
>> 3. Perform conversion, such as creating a new subvolume and moving the
>> contents of the source directory;
>> 4. Thaw the filesystem or restore the subvolume writable property.
>> 
>> In fact, I am not so sure whether this use of freeze is appropriate
>> because the source directory the user needs to convert may be located
>> at / or /home and this pre-check and conversion process may take a long
>> time, which can lead to some shell and graphical application suspended.
>> 
>> Please give your comments if any.
>> 
>

-- 
Thanks,
Lu


