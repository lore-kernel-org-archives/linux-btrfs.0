Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44967 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2GDPqX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 11:46:23 -0400
Received: by ghrr11 with SMTP id r11so6583916ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 08:46:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120704134258.GL5326@twin.jikos.cz>
References: <4FF30B55.6060205@petaramesh.org>
	<20120703152208.GA28701@carfax.org.uk>
	<CAG1y0scaAqck=LYJdfhQa02BsrnBM7=24RFG5j00pb0QSdn1LA@mail.gmail.com>
	<20120704134258.GL5326@twin.jikos.cz>
Date: Wed, 4 Jul 2012 22:46:21 +0700
Message-ID: <CAG1y0sda5EqfVp0rP7eJpTdvFFOfWv2DidJPRDDKkrycHvdJiQ@mail.gmail.com>
Subject: Re: BTRFS fsck apparent errors
From: "Fajar A. Nugraha" <list@fajar.net>
To: dave@jikos.cz, "Fajar A. Nugraha" <list@fajar.net>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 4, 2012 at 8:42 PM, David Sterba <dave@jikos.cz> wrote:
> On Wed, Jul 04, 2012 at 07:40:05AM +0700, Fajar A. Nugraha wrote:
>> Are there any known btrfs regression in 3.4? I'm using 3.4.0-3-generic
>> from a ppa, but a normal mount - umount cycle seems MUCH longer
>> compared to how it was on 3.2, and iostat shows the disk is
>> read-IOPS-bound
>
> Is it just mount/umount without any other activity?

Yes

> Is the fs
> fragmented

Not sure how to check that quickly

> (or aged),

Over 1 year, so yes

> almost full,

df says 83% used, so probably yes (depending on how you define "almost")

~ $ df -h /media/WD-root
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdc2       922G  733G  155G  83% /media/WD-root

~ $ sudo btrfs fi df /media/WD-root/
Data: total=883.95GB, used=729.68GB
System, DUP: total=8.00MB, used=104.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=18.75GB, used=1.49GB
Metadata: total=8.00MB, used=0.00

> has lots of files?

it's a "normal" 1 TB usb disk, with docs, movies, vm images, etc. No
particular lots-of-small-files like maildir or anything like that.


>> # time umount /media/WD-root/
>>
>> real  0m22.419s
>> user  0m0.000s
>> sys   0m0.064s
>>
>> # /proc/10142/stack  <--- the PID of umount process
>
> The process(es) actually doing the work are the btrfs workers, usual
> sucspects are btrfs-cache (free space cache) or btrfs-ino (inode cache)
> that are writing the cache states back to disk.

Not sure about that, since iostat shows it's mostly read, not write.
Will try iotop later.
I tested also with Chris' for-linus on top of 3.4, same result (really
long time to umount).

Reverting back to ubuntu's 3.2.0-26-generic, umount only took less than 1 s :P
So I guess I'm switching back to 3.2 for now.

-- 
Fajar
