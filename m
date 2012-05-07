From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 22:21:00 +0200
Message-ID: <C8PDRKGPCXB@helmut.hullen.de>
References: <4FA822CB.9090008@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA822CB.9090008@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Daniel,

Du meintest am 07.05.12:

>> Yes - I know. But btrfs promises that I can add bigger disks and
>> delete smaller disks "on the fly". For something like a video
>> collection which will grow on and on an interesting feature. And
>> such a (big) collection does need a "gradfather-father-son" backup,
>> that's no critical data.
>>
>> With a file system like ext2/3/4 I can work with several directories
>> which are mounted together, but (as said before) one broken disk
>> doesn't disturb the others.

> How can you do that with ext2/3/4? If you mean create several
> different filesystems and mount them separately then that's very
> different from your current situation. What you did in this case is
> comparable to creating a raid0 array out of your disks. I don't see
> how an ext filesystem is going to work any better if one of the disks
> drops out than with a btrfs filesystem.

  mkfs.btrfs  -m raid1 -d raid0

with 3 disks gives me a "cluster" which looks like 1 disk/partition/ 
directory.
If one disk fails nothing is usable.

(Yes - I've read Hugo's explanation of "-d single", I'll try this way)

With ext2/3/4 I mount 2 disks/partitions into the first disk. If one  
disk fails the contents of the 2 other disks is still readable,

> It sounds like what you're thinking of is creating several separate
> ext filesystems and then just mounting them separately.

Yes - that's the old way. It's reliable but "ugly".

> There's nothing inherently special about doing this with ext, you can
> do the same thing with btrfs and it would amount to about the same
> level of protection (potentially more if you consider [meta]data
> checksums important but potentially less if you feel that ext is more
> robust for whatever reason).

No - as just mentionend: there's a big difference when one disk fails.

> If you want to survive losing a single disk without the (absolute)
> fear of the whole filesystem breaking you have to have some sort of
> redundancy either by separating filesystems or using some version of
> raid other than raid0.

No - since some years I use a kind of outsourced backup. A copy of all  
data is on a bundle of disks somewhere in the neighbourhood. As  
mentionend: the data isn't business critical, it's just "nice to have".  
It's not worth something like raid1 or so (with twice the costs of a non  
raid solution).

> I suppose the volume management of btrfs is
> sort of confusing at the moment but when btrfs promises you can
> remove disks "on the fly" it doesn't mean you can just unplug disks
> from a raid0 without telling btrfs to put that data elsewhere first.

No - it's not confusing. It only needs a kind of recipe and much time:

        btrfs device add ...
        btrfs filesystem balance ... (perhaps no necessary)
        btrfs device delete ...
        btrfs filesystem balance ... (perhaps not necessary)

No intellectual challenge.
And completely different to "hot pluggable".

Viele Gruesse!
Helmut
