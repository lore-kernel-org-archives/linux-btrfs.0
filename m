From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 10:09:48 +0800
Message-ID: <4EEAA86C.4080706@cn.fujitsu.com>
References: <4EEA4124.20907@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEA4124.20907@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2011 02:49 AM, Tobias wrote:
> Hi all!
> 
> My BTRFS-FS ist getting really slow. Reading is ok, writing is slow and
> deleting is horrible slow.
> 
> There are many files and many links on the FS.
> 
> # btrfs filesystem df /srv/storage
> Data: total=3.09TB, used=3.07TB
> System, DUP: total=8.00MB, used=496.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=154.88GB, used=70.56GB
> Metadata: total=8.00MB, used=0.00
> 
> Maybe it's because there is so much Metadata and it needs so many seeks
> on the discs when deleting?
> 
> I'd like to delete some of the old Files but its so horrible slow that i
> think its maybe faster to copy all needed Data to a different Disc,
> killing the FS and move the Files back...
> 
> The machine is a QuadCore with 8GB RAM. Kernel is "3.1+for-linus".
> 
> Any hints how i could speed it up?
> 


I recommend to run defragment on your files,
it should help you, although defrag maybe slow, too.

thanks,
liubo

> Tobias
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

