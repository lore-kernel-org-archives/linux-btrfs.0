Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50266 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752038AbdGCViq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 17:38:46 -0400
Subject: Re: Deleting mounted subvolumes
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
 <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
 <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5787bb34-0cfa-f074-505b-0c482cc16aee@mendix.com>
Date: Mon, 3 Jul 2017 23:38:43 +0200
MIME-Version: 1.0
In-Reply-To: <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2017 10:48 PM, Pete wrote:
> On 07/03/2017 12:30 AM, Hans van Kranenburg wrote:
>> On 07/02/2017 11:33 PM, Pete wrote:
>>> I found that I can delete a mounted subvolume using:
>>> btrfs subvolume delete <mounted sub volume>
>>>
>>> This works.  Is this the intended action?  To me it would seem like a
>>> warning and the command exiting would make sense?
>>
>> Yes, you can do that. It's a bit similar to the fact that you can also
>> delete a regular file when it's still open by another program.
> 
> I was expecting it to behave somewhat like trying to unmount an active
> filesystem, where you are prevented from doing so.
> 
> Aside: the way I found out was that the backup script I was writing,
> rather than deleting the read only snapshots deleted the source
> subvolumes, nearly everything on the system apart from the snapshots...

Heh.. :)

>> But, still having a file open (inode, filedescriptor, what's it
>> called...) does actually block the cleaner process from progressing
>> beyond that point.
>>
>> You can also delete a subvolume which is not separately mounted, while a
>> process still has open files in it.
>>
> 
> You'd have to do that from within the mounted parent subvolume, I think,
> so that looks more normal?
> 
>> In case of deleting a mounted subvolume... it's a bit different. As long
>> as it's mounted, even if nothing else is using a file within, it won't
>> be actually completely deleted in the background, unless the final
>> umount is done. What can happen (I just tried it) is that the mount
>> point ends up looking completely empty already in the meantime, as soon
>> as no files are open and after I cd .. out of it. If I cd back into the
>> mount point, there's nothing any more and any action to create something
>> new within will end up with a "No such file or directory".
>>
>> Only when doing the umount, the subvolume completely disappears.
>>
> 
> So provided I did not unmount the deleted subvols then I could actually
> have undeleted them? Of does that require developer level skills?  Too
> late now, and I recovered from snapshots and a little data from the
> backup drive.  Also I'd think dangerous to offer this option as people
> might assume they could rely on it which might be a dangerous assumption.

Not really, it's halfway gone through the grinder already. Deleting a
subvolume means looking at all the files that are in the filetree of
that subvolume, looking at all extents they reference, and then for all
of those extents lower reference counts, and free all space for extents
that are not used by anyone else any more.

If that's done, then removing the actual filesystem root object if it's
held by some mount reference (as I imagine it would be) in the kernel is
just the last straw.

-- 
Hans van Kranenburg
