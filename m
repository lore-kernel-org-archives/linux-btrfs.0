Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43450 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175AbaFZSl5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 14:41:57 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56123 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X0EcP-003CSF-2r
	for linux-btrfs@vger.kernel.org; Thu, 26 Jun 2014 12:41:57 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
Date: Thu, 26 Jun 2014 12:41:55 -0600
Message-Id: <56CE0D0C-EE96-4CBC-B7CB-FC42CA1B01DF@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <2316027.LZEnVG8laK@xev> <CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com> <6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com> <CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com> <53A6DDAD.8070804@chinilu.com> <99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com> <pan$600a2$3927cc39$ae007590$e90b8415@cox.net> <yq1bntjizkr.fsf@sermon.lab.mkp.net> <CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 25, 2014, at 7:01 AM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

> On 6/23/14, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>> Anyway. The short answer is that Linux will pretty much always do I/O in
>> multiples of the system page size regardless of the logical block size
>> of the underlying device. There are a few exceptions to this such as
>> direct I/O, legacy filesystems using bufferheads and raw block device
>> access.
> 
> Thanks for the clarification.
> 
> And some random notes:
> 
> Note that gdisk gives default 8 sector alignment value for AF disks.
> That is 'sector' meant by gdisk is 'Logical Sector'!
> Sufficiently determined user may create misaligned
> partitions by playing with alignment value and partition start/end
> values.
> 
> There are SSDs with 4K, 8K block/page sizes and
> 512K, 1M, 1.5M Erase block sizes.
> 
> Partitions should be aligned with Erase blocks.
> 

That sounds plausible, but the FTL in the consumer SSD's most all of us are buying isn't going to give you any assurance it's actually writing with such boundaries in mind. You may have partition 1 start on LBA 2048, which is 1MB aligned, but as soon as you're writing data to LBA 2048 through say LBA 2560, for all you know that write actually ends up in pages that are located in the first and second erase blocks; or maybe all of it's in the 8th erase block. The OS side of things we don't have insight or control over this.

Also these days parted, fdisk and gdisk should all be starting partition 1 at LBA 2048, 1MB aligned. Some differences come into play with 4096/4096 logical/physical sector drives, but so far I've only seen this as the result of USB enclosures. I haven't seen 4Kn AF bare drives in the wild thus far.


Chris Murphy