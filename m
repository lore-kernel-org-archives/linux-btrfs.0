From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: error during umuont after set-default with 2.6.34-rc2
Date: Mon, 22 Mar 2010 22:25:50 +0200
Message-ID: <4BA7D24E.3040600@cs.bgu.ac.il>
References: <201003212045.o2LKjBgg002162@indigo.cs.bgu.ac.il> <20100322133858.GB32521@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100322133858.GB32521@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/22/2010 03:38 PM, Chris Mason wrote:
> On Sun, Mar 21, 2010 at 10:45:11PM +0200, Alexander Piavlo wrote:
>   
>> Hi,
>> trying the new btrfs tool and set-default with 2.6.34-rc2 i hit the the
>> following problem:
>>
>> mkfs.btrfs -d single /dev/sys/btrfs
>> mount -t btrfs /dev/sys/btrfs /btrfs
>> btrfs subvolume create /btrfs/newroot
>> mkdir /btrfs/newroot/.btrfs
>> btrfs subvolume set-default 256 /btrfs
>> umount /btrfs
>> mount -t btrfs /dev/sys/btrfs /btrfs
>>
>> up till now everything works ok
>>
>> A question How do i access or mount the original root of btrfs? Which
>> tree id does it have?
>> It would be great if "btrfs subvolume list ..." would also list the
>> original root.
>>
>> I guessed I need to use 0, so i tried:
>>   mount -t btrfs -o subvol=0 /dev/sys/btrfs /btrfs/.btrfs
>> and:
>>   mount -t btrfs -o subvol=. /dev/sys/btrfs /btrfs/.btrfs
>> but in both cases it mounted the newroot subvolume with id 256 under
>> /btrfs/.btrfs
>>
>> So I tried setting the original root back with:
>>   btrfs subvolume set-default 0 /btrfs
>>     
> Looks like set-default needs to understand 0 means use the old default,
>   

old default = previous default

or

old default = top level subvolume
?

> I'll add this in.
>
> btrfs subvolume set-default 5 /btrfs
>
>   
Why 5? is this the tree id of the root subvolume = top level path?
> or mount -o subvolid=0 /dev/xxx /mnt
> or mount -o subvolid=5 /dev/xxx /mnt
>   
Did not know about the subvolid option, I though one can pass treeid to
subvol option.

Thanks

> -chris
>   

