Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40451 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752313AbaKBV5Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 16:57:24 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56964 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xl39H-004FRg-Nk
	for linux-btrfs@vger.kernel.org; Sun, 02 Nov 2014 14:57:23 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: filesystem corruption
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5455B7E7.3020404@pobox.com>
Date: Sun, 2 Nov 2014 14:57:22 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 1, 2014, at 10:49 PM, Robert White <rwhite@pobox.com> wrote:

> On 10/31/2014 10:34 AM, Tobias Holst wrote:
>> I am now using another system with kernel 3.17.2 and btrfs-tools 3.17
>> and inserted one of the two HDDs of my btrfs-RAID1 to it. I can't add
>> the second one as there are only two slots in that server.
>> 
>> This is what I got:
>> 
>>  tobby@ubuntu: sudo btrfs check /dev/sdb1
>> warning, device 2 is missing
>> warning devid 2 not found already
>> root item for root 1746, current bytenr 80450240512, current gen
>> 163697, current level 2, new bytenr 40074067968, new gen 163707, new
>> level 2
>> Found 1 roots with an outdated root item.
>> Please run a filesystem check with the option --repair to fix them.
>> 
>>  tobby@ubuntu: sudo btrfs check --repair /dev/sdb1
>> enabling repair mode
>> warning, device 2 is missing
>> warning devid 2 not found already
>> Unable to find block group for 0
>> extent-tree.c:289: find_search_start: Assertion `1` failed.
> 
> The read-only snapshots taken under 3.17.1 are your core problem.
> 
> Now btrfsck is refusing to operate on the degraded RAID because degraded RAID is degraded so it's read-only. (this is an educated guess).

Degradedness and writability are orthogonal. If there's some problem with the fs that prevents it from being mountable rw, then that'd apply for both normal and degraded operation. If the fs is OK, it should permit writable degraded mounts.

> Since btrfsck is _not_ a mount type of operation its got no "degraded mode" that would let you deal with half a RAID as far as I know.

That's a problem. I can see why a repair might need an additional flag (maybe force) to repair a volume that has the minimum number of devices for degraded mounting, but not all are present. Maybe we wouldn't want it to be easy to accidentally run a repair that changes the file system when a device happens to be missing inadvertently that could be found and connected later.

I think related to this is a btrfs equivalent of a bitmap. The metadata already has this information in it, but possibly right now btrfs lacks the equivalent behavior of mdadm readd when a previously missing device is reconnected. If it has a bitmap then it doesn't have to be completely rebuilt, the bitmap contains information telling md how to "catch up" the readded device, i.e. only that which is different needs to be written upon a readd.

For example if I have a two device Btrfs raid1 for both data and metadata, and one device is removed and I mount -o degraded,rw one of them and make some small changes, unmount, then reconnect the missing device and mount NOT degraded - what happens? I haven't tried this. And I also don't know if a full balance (hours) is needed to "catch up" the formerly missing device. With md this is very fast - seconds/minutes depending on how much has been changed.


Chris Murphy

