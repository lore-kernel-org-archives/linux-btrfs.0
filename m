Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:39951 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbeCIQ6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 11:58:23 -0500
Received: by mail-it0-f44.google.com with SMTP id e64-v6so3585766ita.5
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Mar 2018 08:58:22 -0800 (PST)
Subject: Re: How to replace a failed drive in btrfs RAID 1 filesystem
To: Paul Richards <paul.richards@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAMoswehA9P+JEoLmrMcWDys8t_pgNQxjvSGsk5XHhshFo+=e-Q@mail.gmail.com>
 <923562e4-7069-7541-0500-e16c302893dc@gmail.com>
 <CAMoswegyGSote6U3z+aE3fJ+ihPbsXLqUwY9K3GnmtjGSF7o0g@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8d2f0158-0976-9030-7cfc-e673825bc566@gmail.com>
Date: Fri, 9 Mar 2018 11:58:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAMoswegyGSote6U3z+aE3fJ+ihPbsXLqUwY9K3GnmtjGSF7o0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-09 11:53, Paul Richards wrote:
> Fantastic response!  Thank you.
> 
> I haven’t investigated how broken the failed drive is, I just shutdown 
> as soon as I noticed.
> 
> The 3 drives were 8, 8 and 2 TB.  The 2TB one failed and I’m replacing 
> it with a new 8TB.  So the new drive is indeed larger.  If I do a 
> “replace” I’ll end up with the same block distribution as before, so 
> would likely want to balance afterwards.
Yes, you probably do, but you'll also need to resize the device first 
(which I forgot to mention in my reply), as replace doesn't expand that 
part of the volume to fill the new device.
> 
> I think, but I’ll need to confirm, that I have enough free space to do a 
> mount degraded, delete, remount non-degraded again, then add, and 
> rebalance.  This will leave me in degraded mode for the shortest time if 
> my understanding is correct.
Assuming you can fit all the data on the two 8TB drives, then yes this 
will result int he shortest amount of time running degraded (although, 
if the failed drive is mostly working, you may not need to mount 
degraded at all to do this), though keep in mind that this will also 
result in significant load on the other disks and will give you degraded 
performance for the longest amount of time.
> 
> Thanks again for your notes, they should be on the wiki..  :)
I've been meaning to add it for a while actually, I just haven't gotten 
around to it yet.
> 
> 
> 
> On Fri, 9 Mar 2018 at 16:43, Austin S. Hemmelgarn <ahferroin7@gmail.com 
> <mailto:ahferroin7@gmail.com>> wrote:
> 
>     On 2018-03-09 11:02, Paul Richards wrote:
>      > Hello there,
>      >
>      > I have a 3 disk btrfs RAID 1 filesystem, with a single failed drive.
>      > Before I attempt any recovery I’d like to ask what is the recommended
>      > approach?  (The wiki docs suggest consulting here before attempting
>      > recovery[1].)
>      >
>      > The system is powered down currently and a replacement drive is being
>      > delivered soon.
>      >
>      > Should I use “replace”, or “add” and “delete”?
>      >
>      > Once replaced should I rebalance and/or scrub?
>      >
>      > I believe that the recovery may involve mounting in degraded
>     mode.  If
>      > I do this, how do I later get out of degraded mode, or if it’s
>      > automatic how do i determine when I’m out of degraded mode?
>      >
>     It won't automatically mount degraded, you either have to explicitly ask
>     it to, or you have to have an option to do so in your default mount
>     options for the volume in /etc/fstab (which is dangerous for multiple
>     reasons).
> 
>     Now, as to what the best way to go about this is, there are three things
>     to consider:
> 
>     1. Is the failed disk still usable enough that you can get good data off
>     of it in a reasonable amount of time?  If you're replacing the disk
>     because of a lot of failed sectors, you can still probably get data off
>     of it, while something like a head crash isn't worth trying to get data
>     back.
>     2. Do you have enough room in the system itself to add another disk
>     without removing one?
>     3. Is the replacement disk at least as big as the failed disk?
> 
>     If the answer to all three is yes, then just put in the new disk, mount
>     the volume normally (you don't need to mount it degraded if the failed
>     disk is working this well), and use `btrfs replace` to move the data.
>     This is the most efficient option in terms of both time and is also
>     generally the safest (and I personally always over-spec drive-bays in
>     systems we build where I work specifically so that this approach can be
>     used).
> 
>     If the answer to the third question is no, put in the new disk (removing
>     the failed one first if the answer to the second question is no), mount
>     the volume (mount it degraded if one of the first two questions is no,
>     normally otherwise), then add the new disk to the volume with `btrfs
>     device add` and remove the old one with `btrfs device delete` (using the
>     'missing' option if you had to remove the failed disk).  This is needed
>     because the replace operation requires the new device to be at least as
>     big as the old one.
> 
>     If the answer to either one or two is no but the answer to three is yes,
>     pull out the failed disk, put in a new one, mount the volume degraded,
>     and use `btrfs replace` as well (you will need to specify the device ID
>     for the now missing failed disk, which you can find by calling `btrfs
>     filesystem show` on the volume).  In the event that the replace
>     operation refuses to run in this case, instead add the new disk to the
>     volume with `btrfs device add` and then run `btrfs device delete
>     missing` on the volume.
> 
>     If you follow any of the above procedures, you don't need to balance
>     (the replace operation is equivalent to a block level copy and will
>     result in data being distributed exactly the same as it was before,
>     while the delete operation is a special type of balance), and you
>     generally don't need to scrub the volume either (though it may still be
>     a good idea).  As far as getting back from degraded mode, you can just
>     remount the volume to do so, though I would generally suggest rebooting.
> 
>     Note that there are three other possible approaches to consider as well:
> 
>     1. If you can't immediately get a new disk _and_ all the data will fit
>     on the other two disks, use `btrfs device delete` to remove the failed
>     disk anyway, and run with just the two until you can get a new disk.
>     This is exponentially safer than running the volume degraded until you
>     get a new disk, and is the only case you realistically should delete a
>     device before adding the new one.  Make sure to balance the volume after
>     adding the new device.
>     2. Depending on the situation, it may be faster to just recreate the
>     whole volume from scratch using a backup than it is to try to repair it.
>        This is actually the absolute safest method of handling this
>     situation, as it makes sure that nothing from the old volume with the
>     failed disk causes problems in the future.
>     3. If you don't have a backup, but have some temporary storage space
>     that will fit all the data from the volume, you could also use `btrfs
>     restore` to extract files from the old volume to temporary storage,
>     recreate the volume, and copy the data back in from the temporary
>     storage.
> 

