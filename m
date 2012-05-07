From: Daniel Lee <longinus00@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 07 May 2012 12:30:19 -0700
Message-ID: <4FA822CB.9090008@gmail.com>
References: <C8PD2qZuCXB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PD2qZuCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2012 10:52 AM, Helmut Hullen wrote:
> Hallo, Felix,
>
> Du meintest am 07.05.12:
>
>>> I'm just going back to ext4 - then one broken disk doesn't disturb
>>> the contents of the other disks.
>
>> ?! If you use raid0 one broken disk will always disturb the contents
>> of the other disks, that is what raid0 does, no matter what
>> filesystem you use.
>
> Yes - I know. But btrfs promises that I can add bigger disks and delete
> smaller disks "on the fly". For something like a video collection which
> will grow on and on an interesting feature. And such a (big) collection
> does need a "gradfather-father-son" backup, that's no critical data.
>
> With a file system like ext2/3/4 I can work with several directories
> which are mounted together, but (as said before) one broken disk doesn't
> disturb the others.
>

How can you do that with ext2/3/4? If you mean create several different 
filesystems and mount them separately then that's very different from 
your current situation. What you did in this case is comparable to 
creating a raid0 array out of your disks. I don't see how an ext 
filesystem is going to work any better if one of the disks drops out 
than with a btrfs filesystem. Using -d single isn't going to be of much 
use in this case either because that's like spanning a lvm volume over 
several disks and then putting ext over that, it's pretty 
nondeterministic how much you'll actually save should a large chunk of 
the filesystem suddenly disappear.

It sounds like what you're thinking of is creating several separate ext 
filesystems and then just mounting them separately. There's nothing 
inherently special about doing this with ext, you can can do the same 
thing with btrfs and it would amount to about the same level of 
protection (potentially more if you consider [meta]data checksums 
important but potentially less if you feel that ext is more robust for 
whatever reason).

If you want to survive losing a single disk without the (absolute) fear 
of the whole filesystem breaking you have to have some sort of 
redundancy either by separating filesystems or using some version of 
raid other than raid0. I suppose the volume management of btrfs is sort 
of confusing at the moment but when btrfs promises you can remove disks 
"on the fly" it doesn't mean you can just unplug disks from a raid0 
without telling btrfs to put that data elsewhere first.
