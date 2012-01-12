From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: btrfs-related kernel oops due to media error
Date: Thu, 12 Jan 2012 23:39:21 +0100
Message-ID: <4F0F6119.4000605@gmail.com>
References: <4F0B6BCB.80308@gmail.com> <40bebf953d60c05eff25fbde5bfbef17.squirrel@webmail.decarpentier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Niels de Carpentier <niels@decarpentier.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <40bebf953d60c05eff25fbde5bfbef17.squirrel@webmail.decarpentier.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Jan 10, 2012 at 00:01, Niels de Carpentier 
<niels@decarpentier.com <mailto:niels@decarpentier.com>> wrote:

     > Hi,
     >
     > One of my disks, partitioned into a single btrfs partition, is
    showing
     > media errors. The problem is that these errors lead to kernel
    panic from
     > btrfs - that make the filesystem unusable until reboot - and
    therefore
     > it is very hard for me to do a full backup of the data prior to
    changing
     > the disk.
     > My current kernel is 3.2.0-8-generic from Ubuntu/precise (based
    on linux
     > 3.2-final) but I quickly tested and get the same error with an
    older 3.1
     > kernel (and I can probably reproduce it with a vanilla kernel if
     > necessary).
     > I assume that the filesystem should not panic even in case of a media
     > error... Is there any procedure I can follow / patch I could apply to
     > salvage my data while ignoring media errors ?

    I don't know about btrfs, but writing the sector with hdparm
    --write-sector will usually cause it to be remapped. You can use dd or
    another tool to read the entire disk to find out if there are more bad
    sectors.

    Niels


Thanks you for the hint !
I'll probably try this but since I've already managed to make a copy of 
all my interesting data, I think I'll keep the disk in the same state 
(with the bad sectors not remapped) for a few days, hoping the btrfs 
developers are interested in fixing this bug... Who will trust a 
filesystem that OOPs on media failure ? ;-)

Vincent

