From: "Chris Samuel" <chris@csamuel.org>
Subject: Re: Bug in mkfs.btrfs?!
Date: Sun, 23 Jan 2011 09:54:34 +1100
Message-ID: <c4e20f24127699d27aca4fa8c56f4d33.squirrel@csamuel.org>
References: <20110122144513.GA2539@scooter> <20110122145222.GB2539@scooter>
    <20110122151124.GC29985@carfax.org.uk>
    <20110122155612.GA3664@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110122155612.GA3664@scooter>
List-ID: <linux-btrfs.vger.kernel.org>


On Sun, January 23, 2011 2:56 am, Felix Blanke wrote:


> It was a simple:
>
> mkfs.btrfs -L backup -d single /dev/loop2
>
> But it also happens without the options, like:
>
> mkfs.btrfs /dev/loop2
>
>
> /dev/loop2 is a loop device, which is aes encrypted. The output of
> "losetup /dev/loop2":
>
> /dev/loop2: [0010]:5324
> (/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3)
> encryption=AES128

I'm not familiar with losetup, is /dev/loop2 a symlink ?

If so could you post an ls -l of /dev/loop2 please ?

cheers,
Chris
-- 
Chris Samuel, Melbourne, Australia
http://www.csamuel.org/

