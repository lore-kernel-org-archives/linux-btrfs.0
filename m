Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39876 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJKIwd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 04:52:33 -0400
Date: Sat, 11 Oct 2014 16:52:17 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Rich Rauenzahn <rich@shroop.net>
Cc: Rich Rauenzahn <rrauenza@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
Message-ID: <20141011085216.GA29666@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
 <20141007020538.GA3187@localhost.localdomain>
 <54334D5E.9000300@shroop.net>
 <20141008142030.GA13823@localhost.localdomain>
 <543562C6.3030604@shroop.net>
 <20141009071337.GA13470@localhost.localdomain>
 <5436BE9B.90300@shroop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5436BE9B.90300@shroop.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 09, 2014 at 09:58:03AM -0700, Rich Rauenzahn wrote:
> On 10/9/2014 12:13 AM, Liu Bo wrote:
> >sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /
> 
> $ sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /
> ioctl ret=0, total_size=4096, bytes_left=4080, bytes_missing=0,
> cnt=0, missed=0

Hi Rich,

So cnt=0 is the reason that we got nothing output, however,
to be honest, I don't know exactly why 'cnt' is 0, perhaps it's due to an old
version btrfs, as the 'btrfs inspect-internal' command depends on ioctl which
may have bugs in old btrfs.

> 
> I also tried -P and -s 100000000 ....
> 
> Also did this:
> 
> $ sudo ./btrfs-map-logical  -l 58464632832   -o /tmp/58464632832 /dev/sdf3
> mirror 1 logical 58464632832 physical 1536393216 device /dev/sdg3
> mirror 2 logical 58464632832 physical 58464632832 device /dev/sdf3
> 
> And looked at the 4k block.  strings doesn't show anything useful: +V0T"
> File doesn't recognize it as anything particular.
> 
> Weird.

One ultimate solution is to use 'btrfs-debug-tree' to dump the human readable
metadata information and grep for 58464632832 to read inode info. ,
but this may cost time depending on the size of your patition.

thanks,
-liubo

> 
> I have one other clue which I think is irrelevant.  I had another
> error on a different drive/different fs and it turned out to be the
> vmem file for a virtual machine under vmware workstation.  I deleted
> the file since it was just the memory image and the error went away.
> It was easy to map the bad block to the file from dmesg and the
> inode.   I may have also created a vm at some point on this drive
> we're looking at now and then moved it.  So I think that information
> is not relevant... but maybe you've seen this before.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
