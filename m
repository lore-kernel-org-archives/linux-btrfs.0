Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:46286 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdK1UFT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 15:05:19 -0500
Received: by mail-it0-f48.google.com with SMTP id t1so1212349ite.5
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 12:05:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171128184828.GB3553@twin.jikos.cz>
References: <20171127094156.GC29491@fnst.localdomain> <20171128184828.GB3553@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 28 Nov 2017 23:04:37 +0300
Message-ID: <CAGqmi748FR6iZFUWxs_4dQ+m0ZsO5xsKWbFwtfhu1twNVeOmBA@mail.gmail.com>
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
To: David Sterba <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-11-28 21:48 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Mon, Nov 27, 2017 at 05:41:56PM +0800, Lu Fengqi wrote:
>> As we all know, under certain circumstances, it is more appropriate to
>> create some subvolumes rather than keep everything in the same
>> subvolume. As the condition of demand change, the user may need to
>> convert a previous directory to a subvolume. For this reason，how about
>> adding an ioctl to convert a directory to a subvolume?
>
> I'd say too difficult to get everything right in kernel. This is
> possible to be done in userspace, with existing tools.
>
> The problem is that the conversion cannot be done atomically in most
> cases, so even if it's just one ioctl call, there are several possible
> intermediate states that would exist during the call. Reporting where
> did the ioctl fail would need some extended error code semantics.
>
>> Users can convert by the scripts mentioned in this
>> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is
>> it easier to use the off-the-shelf btrfs subcommand?
>
> Adding a subcommand would work, though I'd rather avoid reimplementing
> 'cp -ax' or 'rsync -ax'.  We want to copy the files preserving all
> attributes, with reflink, and be able to identify partially synced
> files, and not cross the mountpoints or subvolumes.
>
> The middle step with snapshotting the containing subvolume before
> syncing the data is also a valid option, but not always necessary.
>
>> After an initial consideration, our implementation is broadly divided
>> into the following steps:
>> 1. Freeze the filesystem or set the subvolume above the source directory
>> to read-only;
>
> Freezing the filesystme will freeze all IO, so this would not work, but
> I understand what you mean. The file data are synced before the snapshot
> is taken, but nothing prevents applications to continue writing data.
>
> Open and live files is a problem and don't see a nice solution here.
>
>> 2. Perform a pre-check, for example, check if a cross-device link
>> creation during the conversion;
>
> Cross-device links are not a problem as long as we use 'cp' ie. the
> manual creation of files in the target.
>
>> 3. Perform conversion, such as creating a new subvolume and moving the
>> contents of the source directory;
>> 4. Thaw the filesystem or restore the subvolume writable property.
>>
>> In fact, I am not so sure whether this use of freeze is appropriate
>> because the source directory the user needs to convert may be located
>> at / or /home and this pre-check and conversion process may take a long
>> time, which can lead to some shell and graphical application suspended.
>
> I think the closest operation is a read-only remount, which is not
> always possible due to open files and can otherwise considered as quite
> intrusive operation to the whole system. And the root filesystem cannot
> be easily remounted read-only in the systemd days anyway.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

My two 2c,
Then we talking about 'fast' (i.e. i like the idea where ioctl calls
to be fast) conversion of dir to subvolume,
can be done like that (sorry if i miss understood something and that a
rave or i'm crazy..):

For make idea more clear, for userspace that can looks like:
1. Create snapshot of parent subvol for that dir
2. Cleanup all data, except content of dir in snapshot
3. Move content of that dir to snapshot root
4. Replace dir with that snapshot/subvol
i.e. no copy, no cp, only rename() and garbage collecting.

In kernel that in "theory" will looks like:
1. Copy of subvol root inode
2. Replace root inode with target dir inode
3. Replace target dir in old subvol with new subvol
4. GC old dir content from parent subvol, GC all useless content of
around dir in new subvol

That's may be a fastest way for user, but that will not solve problems
with opened files & etc,
but that must be fast from user point of view, and all other staff can
be simply cleaned in background

Thanks
-- 
Have a nice day,
Timofey.
