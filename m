From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 08 May 2012 19:24:32 +0200
Message-ID: <4FA956D0.30307@gmail.com>
References: <C8TFrQEeCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TFrQEeCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/8/12 6:53 PM, Helmut Hullen wrote:
 > Hallo, Felix,
 >
 > Du meintest am 08.05.12:
 >
 >>> Why should I use RAID0 with a bundle of ext2/3/4? Mounting on/in the
 >>> directory tree does the job.
 >
 >> Nobody told you that you should do it. What EVERYBODY here is telling
 >> you: The problem you have right now would be the same damn problem,
 >> no matter what fs you would you. Every fs will be unusable if you
 >> lose one disk in a raid0 setup. That's all what we are trying to tell
 >> you for the last 15 mails :)
 >
 >> If you don't see any benefits using btrfs then simply don't  use it
 >
 > I still hope for a benefit when I use btrfs.
 >
 > As I've written many times: I want a system for my video collection
 > which allows
 >
 >          adding a bigger disk
 >          deleting/removing a smaller disk
 >
 > with simple commands.
 >
 > btrfs seems to be able to do that (and I have tested this job many
 > times). But with my configuration "mkfs.btrfs -m raid1 -d raid0" I've
 > (again) seen that all data vanishes when 1 disk fails.
 >
 > I'll try Hugo's proposal "mkfs.btrfs -m raid1 -d single".
 > And I hope that it doesn't make all disks unreadable when 1 disk fails.

Maybe you should inform yourself about the different raid level before 
you use them?

http://en.wikipedia.org/wiki/Standard_RAID_levels#RAID_0

Raid0 will allways be that way: One disk dies, filesystem is gone. 
That's some sort of defintion of raid0 :)

@"-d single"

Is it really possible to remove a disk from btrfs (created with -d 
single) without losing the data on that disk? Is there a way to tell 
balance to copy all the data from this disk to the other disks (ofc if 
there is enough free space on them)?

 >
 > Viele Gruesse!
 > Helmut
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
