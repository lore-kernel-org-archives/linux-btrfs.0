Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:34342 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbdK1TyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:54:04 -0500
Received: by mail-it0-f45.google.com with SMTP id m11so24123911iti.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 11:54:04 -0800 (PST)
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20171127094156.GC29491@fnst.localdomain>
 <20171128184828.GB3553@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <03bdac95-fe87-0a54-c98b-160543b4ecd9@gmail.com>
Date: Tue, 28 Nov 2017 14:54:00 -0500
MIME-Version: 1.0
In-Reply-To: <20171128184828.GB3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-28 13:48, David Sterba wrote:
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
I think you mean it can't be done atomically in an inexpensive manner 
without significant work on the kernel side.  It should in theory be 
possible to do it atomically by watching for and mirroring changes from 
the source directory to the new subvolume.  Such an approach is however 
expensive, and is not guaranteed to ever finish if the source directory 
is under active usage.  The only issue is updating open file descriptors 
to point to the new files.

In short, the flow I'm thinking of is:

1. Create the subvolume in a temporary state that would get cleaned up 
by garbage collection if the FS got remounted.
2. Start watching the directory structure in the source directory for 
changes, recursively, and mirror all such changes to the subvolume as 
they happen.
3. For each file in the source directory and sub-directories, create a 
file in the new subvolume using a reflink, and add start watching that 
file for changes.  Reflink any detected updates to the temporary file.
Beyond this point, there are two possible methods to finish things:
A:
     4. Freeze all userspace I/O to the filesystem.
     5. Update the dentry for the source directory to point to the new 
subvolume, remove the subvolume's 'temporary' status, and force a commit.
     6. Update all open file descriptors to point to the files in the 
new subvolume.
     7. Thaw all userspace I/O to the filesystem.
     8. Garbage collect the source directory and it's contents.
or:
B:
     4. Update the dentry for the source directory to point to the new 
subvolume, remove the subvolume's temporary status, and force a commit.
     5. Keep the old data around until there are no references to it, 
and indirect opens on files that were already open prior to step 4 to 
point to the old file, while keeping watches around for the old files 
that were open.

Prior to step A5 or B4, this can be atomically rolled back by simply 
nuking the temporary subvolume and removing the watches.  After those 
steps, it's fully complete as far as the on-device state is concerned. 
Method A of completing the conversion has less overall impact on 
long-term operation of the system, but may require significant changes 
to the VFS API to be viable (I don't know if some of the overlay stuff 
could be used or not).  Method B will continue to negatively impact 
performance until all the files that were open are closed, but shouldn't 
require as much legwork on the kernel side.  In both cases, it ends up 
working similarly to the device replace operation, or LVM's pvmove 
operation, both of which can be made atomic.

For what it's worth, I am of the opinion that this would be nice to have 
not so that stuff could be converted on-line, but so that you can 
convert a directory more easily off-line.  Right now, it's a serious 
pain in the arse to do such a conversion (the Python code I linked is 
simple because it's using high-level operations out of the shutil 
standard module, and/or the reflink module on PyPI), largely because it 
is decidedly non-trivial to actually copy all the data about a file (and 
both `cp -ax` and `rsync -ax` miss information other than reflinks, most 
notably file attributes normally set by `chattr`).

I personally care less about the atomicity of the operation than the 
fact that it actually preserves _everything_ (with the likely exception 
of EVM and IMA xattrs, but _nothing_ should be preserving those).  IOW, 
I would be perfectly fine with something that does this in the kernel 
but returns -EWHATEVER if there are open files below the source 
directory and blocks modification to them until the switch is done.
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
> syncing the data is also a valid option, but not always necessary. >
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
Avoiding this would be a nice side effect of having it in the kernel, 
but of course is mostly irrelevant because such a kernel-powered 
solution would only be on newer kernels.
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
That's not exactly a systemd specific thing (or a new thing for that 
matter) unless you've got /var on a separate partition (and I know of no 
distributions that do so without manual intervention).
