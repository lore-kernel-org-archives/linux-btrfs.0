From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Re: Question on subvolumes and mount options
Date: Sun, 13 Feb 2011 18:49:58 +0100
Message-ID: <87ei7bj03d.fsf@savara.sat.thregr.org>
References: <87oc6fj30p.fsf@savara.sat.thregr.org>
	<20110213173059.GB5484@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 13 Feb 2011 17:30:59 +0000, Hugo Mills wrote:
>> First: In the / filesystem I create a subvolume named /home. As soon as
>> the subvolume is created, I can already see the entry point in /home
>> without having to mount it separately. Is that expected?
>
>    Yes.

What happens if I mount the home subvolume into a different point, like:

mount -o subvol=home /home2

and then change a file in /home (which is accessible through the default
subvolume)?

Will the change be reflected on both mount points? Or the inverse
(change /home2)?

>> So, which is best? Looks like mounting subvolumes is not necessary.
>
>    I would recommend putting nothing in the root of the filesystem
> *except* subvolumes. i.e. create a "root" subvolume in / that contains
> your root filesystem, and make that the default. Then you can mount
> your btrfs root subvolume (i.e. the thing that contains all the other
> subvolumes) somewhere like /media/btrfs-root, for purposes of managing
> subvolumes.

So you would recommend creating both /root and /home subvolumes, to be
mounted separately, or create /root and /root/home subvolumes?

>> like to use nodatasum except for /home, will the following work?
>> 
>> mount -o nodatasum /dev/x /
>> btrfs subvolume create /home
>> mount -o datasum,subvol=home /dev/x
>
>    I'd expect that to work, although I haven't tried it myself.

What if I remount the /home subvol into /home2. What happens when I
touch a file through /home (nodatasum) and what happens when I use
/home2 - since both are available at the same time?

