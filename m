From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 26 Feb 2012 17:12:00 +0100
Message-ID: <C3b12r9i1uB@helmut.hullen.de>
References: <20120226153036.GB18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226153036.GB18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 26.02.12:

>> Mounting seems to be no problem, but (p.e.) "delete" doesn't kill
>> the btrfs informations shown with (p.e.) "blkid /dev/sdy1",
>> especially it doesn't delete the label.

>    What do you mean by "delete" here?

   btrfs device delete <device> <path>

>    The label is a *filesystem* label, not a label for the block
> device(s) it lives on, so it doesn't make much sense to talk about
> putting an FS label on only one of the devices that the FS is on.

My (planned) usual work (once a year or so):

        btrfs device add <biggerdevice> <path>
        btrfs filesystem balance <path>
        btrfs device delete <smallerdevice> <path>

And the "devices" are (p.e.) /dev/sdj1, /dev/sdk1 etc. (partitions on a  
device).

Therefor I can see some informations via (p.e.)

        blkid /dev/sdj1

I prefer LABELling the devices/partitions, and then I'd seen that the  
option "-L" makes problems when I use it for more than 1 device/ 
partition.

With other file systems there's no real problem with the same label for  
several partitions - it doesn't work. But btrfs bundles these partitions  
(perhaps sometimes/most times regardless of the labels of the other  
partitions).

Viele Gruesse!
Helmut
