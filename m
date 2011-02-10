From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Corrupt filesystem after power failure
Date: Thu, 10 Feb 2011 12:37:55 +0000
Message-ID: <1297341475.32582.688.camel@cheyenne>
References: <AANLkTikujRv82iNQ4vNvyGGqDotH_bOxfFCqqnC0ycU2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikujRv82iNQ4vNvyGGqDotH_bOxfFCqqnC0ycU2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


I'm far from an expert here, but perhaps you would be worth trying a
newer version of the BTRFS drivers, either via a newer kernel or
re-compiling a kernel with updated BTRFS patches.

I would think that the simplest "quick test" to see if this would help
you would be to get a snapshot from Ubuntu's "daily build" live CD iso,
and try mounting the filesystem with that... since it will have a recent
RC of 2.6.38 kernel which has a much more recent BTRFS version than the
2.6.34 which you are using.

http://cdimage.ubuntu.com/daily-live/current/

YMMV, but it's certainly something else to try.

James.


On Thu, 2011-02-10 at 22:29 +1100, Anil Kumar wrote:
> Hi,
> I am using btrfs on my /home successfully for a while now.
> After a power failure I am no longer able to mount it. I tried to use
> btrfsck without any success.
> The backup I have is about a month old, is there a way I can salvage my files?.
> Full backtrace is at http://pastebin.com/4Re7tVFP
>  I am aware of the danger of dataloss and wanted to change the filesystem.
> Anyway it's too late now
> 
> Anil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


