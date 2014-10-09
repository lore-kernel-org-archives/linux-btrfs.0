Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:53427 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbaJIQ6I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 12:58:08 -0400
Message-ID: <5436BE9B.90300@shroop.net>
Date: Thu, 09 Oct 2014 09:58:03 -0700
From: Rich Rauenzahn <rich@shroop.net>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Rich Rauenzahn <rrauenza@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com> <20141007020538.GA3187@localhost.localdomain> <54334D5E.9000300@shroop.net> <20141008142030.GA13823@localhost.localdomain> <543562C6.3030604@shroop.net> <20141009071337.GA13470@localhost.localdomain>
In-Reply-To: <20141009071337.GA13470@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/9/2014 12:13 AM, Liu Bo wrote:
> sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /

$ sudo ./btrfs inspect-internal logical-resolve -v 58464632832  /
ioctl ret=0, total_size=4096, bytes_left=4080, bytes_missing=0, cnt=0, 
missed=0

I also tried -P and -s 100000000 ....

Also did this:

$ sudo ./btrfs-map-logical  -l 58464632832   -o /tmp/58464632832 /dev/sdf3
mirror 1 logical 58464632832 physical 1536393216 device /dev/sdg3
mirror 2 logical 58464632832 physical 58464632832 device /dev/sdf3

And looked at the 4k block.  strings doesn't show anything useful: +V0T"
File doesn't recognize it as anything particular.

Weird.

I have one other clue which I think is irrelevant.  I had another error 
on a different drive/different fs and it turned out to be the vmem file 
for a virtual machine under vmware workstation.  I deleted the file 
since it was just the memory image and the error went away.  It was easy 
to map the bad block to the file from dmesg and the inode.   I may have 
also created a vm at some point on this drive we're looking at now and 
then moved it.  So I think that information is not relevant... but maybe 
you've seen this before.
