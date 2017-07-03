Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:44909 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbdGCUsW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 16:48:22 -0400
Received: from cpc82297-ando7-2-0-cust601.15-1.cable.virginm.net ([82.10.190.90]:51124 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <pete@petezilla.co.uk>)
        id 1dS8GY-001Ng5-4E
        for linux-btrfs@vger.kernel.org; Mon, 03 Jul 2017 21:48:20 +0100
Subject: Re: Deleting mounted subvolumes
To: linux-btrfs@vger.kernel.org
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
 <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
Date: Mon, 3 Jul 2017 21:48:07 +0100
MIME-Version: 1.0
In-Reply-To: <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2017 12:30 AM, Hans van Kranenburg wrote:
> On 07/02/2017 11:33 PM, Pete wrote:
>> I found that I can delete a mounted subvolume using:
>> btrfs subvolume delete <mounted sub volume>
>>
>> This works.  Is this the intended action?  To me it would seem like a
>> warning and the command exiting would make sense?
> 
> Yes, you can do that. It's a bit similar to the fact that you can also
> delete a regular file when it's still open by another program.

I was expecting it to behave somewhat like trying to unmount an active
filesystem, where you are prevented from doing so.

Aside: the way I found out was that the backup script I was writing,
rather than deleting the read only snapshots deleted the source
subvolumes, nearly everything on the system apart from the snapshots...

> But, still having a file open (inode, filedescriptor, what's it
> called...) does actually block the cleaner process from progressing
> beyond that point.
> 
> You can also delete a subvolume which is not separately mounted, while a
> process still has open files in it.
> 

You'd have to do that from within the mounted parent subvolume, I think,
so that looks more normal?



> In case of deleting a mounted subvolume... it's a bit different. As long
> as it's mounted, even if nothing else is using a file within, it won't
> be actually completely deleted in the background, unless the final
> umount is done. What can happen (I just tried it) is that the mount
> point ends up looking completely empty already in the meantime, as soon
> as no files are open and after I cd .. out of it. If I cd back into the
> mount point, there's nothing any more and any action to create something
> new within will end up with a "No such file or directory".
> 
> Only when doing the umount, the subvolume completely disappears.
>

So provided I did not unmount the deleted subvols then I could actually
have undeleted them? Of does that require developer level skills?  Too
late now, and I recovered from snapshots and a little data from the
backup drive.  Also I'd think dangerous to offer this option as people
might assume they could rely on it which might be a dangerous assumption.



