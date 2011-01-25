From: Kaspar Schleiser <kaspar@schleiser.de>
Subject: Re: Synching a Backup Server
Date: Tue, 25 Jan 2011 18:29:35 +0100
Message-ID: <4D3F087F.20905@schleiser.de>
References: <201101060935.14059.CACook@quantum-sci.com> <20110109183030.GA29572@carfax.org.uk> <AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com> <201101221455.45968.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101221455.45968.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/22/2011 02:55 PM, Hubert Kario wrote:
>> It looks like ZFS, Btrfs, and LVM should work in similar manners, but
>> the overloaded terminology (pool, volume, sub-volume, filesystem are
>> different in all three) and new terminology that's only in Btrfs is
>> confusing.
>
> With btrfs you need to have *a* filesystem, once you have it, you can add and
> remove disks/partitions from it, no need to use 'mkfs.btrfs', just 'btrfs'.

That's just a design decision, right? There's no need for a "default" or 
"root" subvolume.

It should be rather easy to change btrfs so that you first have to 
create a "storage pool" which combines disks for btrfs, and on top of 
that you can create "filesystems" which are just subvolumes.

The creation of a "storage pool" could be very similar to the current 
mkfs, just without the creation of a root subvolume.

A new, simpler mkfs would then just create a subvolume on top of the 
"storage pool" that can be mounted.

Regards,
Kaspar
