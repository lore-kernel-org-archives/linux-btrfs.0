From: Brian Rogers <brian@xyzw.org>
Subject: Re: 'ioctl:: Inappropriate ioctl for device' when trying to shrink
 partition
Date: Thu, 13 Jan 2011 03:33:45 -0800
Message-ID: <4D2EE319.1010101@xyzw.org>
References: <1294857915.7377.14.camel@develog-laptop> <AANLkTi=Jn8-7AD8fcX4cyJUC32YQP2-CE8J_cTxnOuOC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Mikael Andersson <mikael@develog.se>, linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Jn8-7AD8fcX4cyJUC32YQP2-CE8J_cTxnOuOC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/12/2011 11:48 AM, Leonidas Spyropoulos wrote:
> On 12 January 2011 18:45, Mikael Andersson<mikael@develog.se>  wrote:
>> E.g. btrfsctl -r -4000m /dev/sda5
>>
> Hey Mikael,
>
> btrfsctl is deprecated, you should use btrfs
> In the previous example:
> btrfs filesystem resize -4000m /dev/sda5

The command isn't asking for the name of the device. It wants the path 
to a mounted btrfs filesystem. So more like:
btrfs filesystem resize -4000m /mnt

Also, the manpage doesn't say this, but you can specify which device to 
resize. If you run 'btrfs filesystem show', it will show a device id for 
each device. Then you can specify the devid to resize like this 
(assuming you want to resize device 2):
btrfs filesystem resize 2:-4000m /mnt

To actually use this space for a new partition, you'll have to delete 
and re-create (without reformatting!) the btrfs partition with the 
smaller size. I don't know if there's a way to do this part on a live 
system without unmounting.

> Check the help of btrfs
>
> And also good to download latest btrfs-progs from git and compile them
> yourself the version of btrfs-progs on LiveCD is old.
>
>
> Latest version I use for example is: v0.19-35-g1b444cd
>
>
>> results in:
>> ioctl:: Inappropriate ioctl for device

I believe you'll also get this same error message if there's not enough 
space to do the shrinking, so be aware of that.

