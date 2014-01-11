Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57013 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751653AbaAKSD6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 13:03:58 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:51765 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W22uZ-002sft-6Q
	for linux-btrfs@vger.kernel.org; Sat, 11 Jan 2014 11:03:55 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS over LVM remounts read-only
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
Date: Sat, 11 Jan 2014 11:03:56 -0700
Message-Id: <FA02685F-A823-48EA-8988-3990CFAAF7C4@colorremedies.com>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com> <20140111150454.GV15634@carfax.org.uk> <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2014, at 10:10 AM, MegaBrutal <megabrutal@gmail.com> wrote:

> 2014/1/11 Hugo Mills <hugo@carfax.org.uk>:
>> 
>>   It looks like you've shrunk the LV without first shrinking the
>> filesystem. Depending on how much you shrunk it by, the odds are
>> fairly good that significant chunks of the FS are now toast.
>> 
>>   Hugo.
>> 
> 
> Thank you very much! Strange, I indeed shrinked the LV, but only by a
> few megabytes to make space for /boot (as turned out, GRUB2 can't boot
> from LVM),

GRUB 2.00 (the final release) can definitely boot from LVs, I do it all the time.

> and I think I did shrink the FS too... But maybe not. As it
> started out as a test system, I intentionally wanted to test some
> obscure situations here. Thankfully I don't have considerable data
> loss and I don't think any valuable data was on the space that was cut
> off. Strange that the system was running like this for a month with
> this problem being undetected.

Only once the file system needed to write outside of the partition would there likely be an error, but from your dmesg "wr 311347" means several hundred thousand failed write attempts. There are probably other messages similar to this going way back.


> 
> How can I shrink the FS to the correct size right now, ensuring that I
> really shrink it to the exact LV size?

Right now it's a broken file system, just recreate it.

Chris Murphy

