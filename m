From: Thomas Kupper <thomas@kupper.org>
Subject: Re: how to check data and metadata type
Date: Sat, 30 Jan 2010 19:28:14 +0100
Message-ID: <DE36CD33-C228-4916-8B20-481A41AE6A3B@kupper.org>
References: <42D1AF99-19ED-4C44-9A01-8039576AA572@kupper.org> <20100130151848.GA7233@localhost.localdomain> <E3FCE606-1BB2-4D76-8DB7-94B3534A8E7F@kupper.org> <4B65C05F.7080806@cs.bgu.ac.il>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B65C05F.7080806@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

On 31 Jan 2010, at 18:39, Piavlo wrote:

> Thomas Kupper wrote:
>> On 30 Jan 2010, at 16:18, Josef Bacik wrote:
>> 
>>> On Fri, Jan 29, 2010 at 11:43:45PM +0100, Thomas Kupper wrote:
>>>> Just a short question:
>>>> 
>>>> How can I check the data and metadata modes of a multi-device btrfs device? btrfs-show is of no help and df is still not showing the correct size of it either (using latest btrfs kernel module and btrfs tools).
>>> There are patches to do this for you, look for the "-i" patch for btrfs-progs
>>> and the "df" patch for the kernel, that will give you the information you are
>>> looking for.  Thanks,
>>> 
>>> Josef
>> 
>> Thanks Josef, I'm stuck with two problems : 
>> 
>> * found the df patch but it does not apply. The latest btrfs-unstable seems not have BTRFS_IOC_SNAP_LISTING, neither btrfs_ioctl_default_subvol. With what revision of btrfs do you work? Of course I could apply it manually but I'm interested in the snap listing, too :)
>> 
>> * I did not succeed in finding the patch '-i'. If you would happen to know where I can find it? I was looking on linux-btrfs mailing list and asked the allknowing Google.
>> 
> 
> look at the patchwork
> http://patchwork.kernel.org/project/linux-btrfs/list/
> the -i is probably this one http://patchwork.kernel.org/patch/72686/

That's exactly what I was looking for. I did know of the patchwork-thingy, perfect place to look for patches obviously.


> Alex
> 
>> 
>> Cheers,
>> Thomas

o/
Thomas

