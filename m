Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39923 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2IZHzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 03:55:48 -0400
Received: by vbbff1 with SMTP id ff1so300130vbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 00:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120925170239.GA2328@localhost.localdomain>
References: <20120920190306.GG2272@localhost.localdomain>
	<20120925164335.GZ14582@twin.jikos.cz>
	<20120925170239.GA2328@localhost.localdomain>
Date: Wed, 26 Sep 2012 09:55:47 +0200
Message-ID: <CAFDW0jLuvH9rMisDz-Y=Y_nwxzzO5K64uixd6mAiaQRmja3izA@mail.gmail.com>
Subject: Re: ENOSPC design issues
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when testing, please also do something like this:

# create big squashfs image somewhere:
# mksquashfs / /big.img -noappend -no-sparse -e big.img

# then unpack into fresh filesystem with (and no) compression:
# unsquashfs -f -d /subvol /big.img

this is how i was always able to trigger ENOSPC while trying to
make a full system installation from squashfs image.

you should also try different compression algos (i only use lzo)

btw: i was able to trigger ENOSPC with for-linus on 3.5.4 on a
i686 Pentium M Notebook with only 1GB of Memory and
fresh FSthis way, otherwise havent seen ENOSPC for long time.

Ahmet

On Tue, Sep 25, 2012 at 7:02 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Tue, Sep 25, 2012 at 10:43:36AM -0600, David Sterba wrote:
>> On Thu, Sep 20, 2012 at 03:03:06PM -0400, Josef Bacik wrote:
>> > I'm going to look at fixing some of the performance issues that crop up because
>> > of our reservation system.  Before I go and do a whole lot of work I want some
>> > feedback.  I've done a brain dump here
>> > https://btrfs.wiki.kernel.org/index.php/ENOSPC
>>
>> Thanks for writing it down, much appreciated.
>>
>> My first and probably naive approach is described in the page, quoting
>> here:
>>
>>  "Attempt to address how to flush less stated below. The
>>  over-reservation of a 4k block can go up to 96k as the worst case
>>  calculation (see above). This accounts for splitting the full tree path
>>  from 8th level root down to the leaf plus the node splits. My question:
>>  how often do we need to go up to the level N+1 from current level N?
>>  for levels 0 and 1 it may happen within one transaction, maybe not so
>>  often for level 2 and with exponentially decreasing frequency for the
>>  higher levels. Therefore, is it possible to check the tree level first
>>  and adapt the calculation according to that? Let's say we can reduce
>>  the 4k reservation size from 96k to 32k on average (for a many-gigabyte
>>  filesystem), thus increasing the space available for reservations by
>>  some factor. The expected gain is less pressure to the flusher because
>>  more reservations will succeed immediately.
>>  The idea behind is to make the initial reservation more accurate to
>>  current state than blindly overcommitting by some random factor (1/2).
>>  Another hint to the tree root level may be the usage of the root node:
>>  eg. if the root is less than half full, splitting will not happen
>>  unless there are K concurrent reservations running where K is
>>  proportional to overwriting the whole subtree (same exponential
>>  decrease with increasing level) and this will not be possible within
>>  one transaction or there will not be enough space to satisfy all
>>  reservations. (This attempts to fine-tune the currently hardcoded level
>>  8 up to the best value). The safe value for the level in the
>>  calculations would be like N+1, ie. as if all the possible splits
>>  happen with respect to current tree height."
>>
>> implemented as follows on top of next/master, in short:
>> * disable overcommit completely
>> * do the optimistically best guess for the metadata and reserve only up
>>   to the current tree height
>>
>
> So I had tried to do this before, the problem is when height changes our reserve
> changes.  So for things like delalloc we say we have X number of extents and we
> reserve that much space, but then when we run delalloc we re-calculate the
> metadata size for X number extents we've removed and that number could come out
> differently since the height of the tree would have changed.  One thing we could
> do is to store the actual reservation with the extent in the io_tree, but I
> think we already use the private for something else so we'd have to add it
> somewhere else.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Ahmet Inan

Systemadministrator

Mathematisches Institut
Albert-Ludwigs-Universität Freiburg
Eckerstr. 1
79104 Freiburg im Breisgau
Tel.: +49(0)761 / 203-5552
Raum: 332
mailto:sysadm@email.mathematik.uni-freiburg.de

Abteilung für Angewandte Mathematik
Albert-Ludwigs-Universität Freiburg
Hermann-Herder-Str. 10
79104 Freiburg im Breisgau
Tel.: +49(0)761 / 203-5626
Raum: 221
mailto:admin@mathematik.uni-freiburg.de

Abteilung für Mathematische Stochastik
Albert-Ludwigs-Universität Freiburg
Eckerstr. 1
79104 Freiburg im Breisgau
Tel.: +49(0)761 / 203-5678
Raum: 249
mailto:helpdesk@stochastik.uni-freiburg.de
