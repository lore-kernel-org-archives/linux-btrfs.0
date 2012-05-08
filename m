From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 18:53:00 +0200
Message-ID: <C8TFrQEeCXB@helmut.hullen.de>
References: <4FA9232C.4020308@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA9232C.4020308@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Felix,

Du meintest am 08.05.12:

>> Why should I use RAID0 with a bundle of ext2/3/4? Mounting on/in the
>> directory tree does the job.

> Nobody told you that you should do it. What EVERYBODY here is telling
> you: The problem you have right now would be the same damn problem,
> no matter what fs you would you. Every fs will be unusable if you
> lose one disk in a raid0 setup. That's all what we are trying to tell
> you for the last 15 mails :)

> If you don't see any benefits using btrfs then simply don't  use it

I still hope for a benefit when I use btrfs.

As I've written many times: I want a system for my video collection  
which allows

        adding a bigger disk
        deleting/removing a smaller disk

with simple commands.

btrfs seems to be able to do that (and I have tested this job many  
times). But with my configuration "mkfs.btrfs -m raid1 -d raid0" I've  
(again) seen that all data vanishes when 1 disk fails.

I'll try Hugo's proposal "mkfs.btrfs -m raid1 -d single".
And I hope that it doesn't make all disks unreadable when 1 disk fails.

Viele Gruesse!
Helmut
