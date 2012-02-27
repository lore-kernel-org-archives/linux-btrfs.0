From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 27 Feb 2012 07:44:00 +0100
Message-ID: <C3f2Sw5i1uB@helmut.hullen.de>
References: <20120226171419.GD18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226171419.GD18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 26.02.12:

>    mkfs.btrfs creates a new filesystem. The -L option sets the label
> for the newly-created FS. It *cannot* be used to change the label of
> an existing FS.

The safest way may be deleting this option ... it seems to work as  
expected only when I create a new FS on 1 disk/partition.

> If you want to do that, use "btrfs filesystem label".

And that seems to work as I expected - fine.

Adding a device works, deleting a device works. Fine!
Now I'll try the job with my Terabyte disks.

(Yes - I have backups ...)

Viele Gruesse!
Helmut
