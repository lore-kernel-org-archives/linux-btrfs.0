From: Brian Rogers <brian@xyzw.org>
Subject: Re: 800 GByte free, but "no space left"
Date: Mon, 06 Dec 2010 01:56:31 -0800
Message-ID: <4CFCB34F.1090504@xyzw.org>
References: <BbJPrrUD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJPrrUD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2010 10:26 AM, Helmut Hullen wrote:
>> So, by far the simplest solution would be to re-create your file
>> system with "single" mode,
> Can I add or delete hard disks/partitions to the two devices/partitions
> in your example?

You can add, but you'll want to avoid deleting, balancing, and 
shrinking. From my testing, any of these operations will convert the 
chunks they relocate to raid0. Then, once you have any raid0 data, btrfs 
will want to allocate all new chunks as raid0 and you'll have the 
unusable space problem again.

> I've studied the man page and the Wiki but didn't find any help.
>
> And in my special case I have to add at least yearly new disks and from
> time to time remove the smallest disks from this bundle.

With the current state of btrfs, you could do this as long as you never 
reduce the total number of disks. When you want to replace an old disk 
with a new one, just go around btrfs: take the filesystem offline and 
copy the old disk's partition into a full-sized partition on the new 
disk. Then remove the old disk and bring the filesystem online again.

It will remember the old size at first, but that can be fixed with

btrfs filesystem resize <devid>:max <path>

Also, if you want metadata redundancy, you have to start your new 
filesystem with two or more disks. Otherwise, the only way to change 
metadata to raid1 is btrfs balance, which must be avoided.

Brian

