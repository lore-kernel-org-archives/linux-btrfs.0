Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:58404 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdGBXaN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 19:30:13 -0400
Subject: Re: Deleting mounted subvolumes
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
Date: Mon, 3 Jul 2017 01:30:10 +0200
MIME-Version: 1.0
In-Reply-To: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2017 11:33 PM, Pete wrote:
> I found that I can delete a mounted subvolume using:
> btrfs subvolume delete <mounted sub volume>
> 
> This works.  Is this the intended action?  To me it would seem like a
> warning and the command exiting would make sense?

Yes, you can do that. It's a bit similar to the fact that you can also
delete a regular file when it's still open by another program.

But, still having a file open (inode, filedescriptor, what's it
called...) does actually block the cleaner process from progressing
beyond that point.

You can also delete a subvolume which is not separately mounted, while a
process still has open files in it.

In case of deleting a mounted subvolume... it's a bit different. As long
as it's mounted, even if nothing else is using a file within, it won't
be actually completely deleted in the background, unless the final
umount is done. What can happen (I just tried it) is that the mount
point ends up looking completely empty already in the meantime, as soon
as no files are open and after I cd .. out of it. If I cd back into the
mount point, there's nothing any more and any action to create something
new within will end up with a "No such file or directory".

Only when doing the umount, the subvolume completely disappears.

-- 
Hans van Kranenburg
