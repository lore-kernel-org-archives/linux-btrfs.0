Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:32585 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3E3O74 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 10:59:56 -0400
Message-ID: <51A7696F.8090407@giantdisaster.de>
Date: Thu, 30 May 2013 16:59:59 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Josef Bacik <JBacik@fusionio.com>, Papp Tamas <tompos@martos.bme.hu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
References: <51A73532.6060900@martos.bme.hu> <20130530123235.GA9829@localhost.localdomain> <51A74C5E.4030201@giantdisaster.de> <20130530140329.23156.38088@localhost.localdomain>
In-Reply-To: <20130530140329.23156.38088@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 30 May 2013 10:03:29 -0400, Chris Mason wrote:
> Quoting Stefan Behrens (2013-05-30 08:55:58)
>> Papp is using an Intel X18-M/X25-M/X25-V G2 SSD. At least with an Intel
>> X25 SSD that identifies itself with "INTEL SSDSA2M080" and on one with
>> the ID "INTEL SSDSA2M040", I've tested whether they honor the flush
>> request. And these two SSDs don't do so, they ignore it. If you cut the
>> power after a flush request completes, the data that was written before
>> the flush request is gone, the write cache was _not_ flushed.
>>
>> You can only disable the write cache during/after every boot "hdparm -W
>> 0 /dev/sd..." (which reduces the SSDs write speed to about 4 MB/s), or
>> avoid such SSDs, or prepare to restore from backup occasionally.
> 
> Hi Stefan,
> 
> How did you verify this?  I'm sure intel will want to hear about it if
> we can reproduce on all filesystems.
> 
> -chris
> 

We have written a kernel module that (among others) is able to write 4KB
block of random data at random locations on an SSD, and in a second step
to read and verify that data.

The test procedure to check SSDs is:
1. Write 4KB blocks of random data to random locations on the disk. Send
a submit_bio(REQ_FLUSH) after each 4KB block. Log the completion of the
write request and of the flush request together with the result value.
2. Somewhere in the middle of operation, switch off all power, drive
presence and SAS data pins between the SSD and the SATA host controller.
3. Wait some time, afterwards enable the connection between the SSD and
the host controller again.
4. Read back the 4KB blocks of random data at random locations using the
same seed value that was used to generate the contents and location when
the blocks were written. Verify the data, log whether the verification
succeeded or failed.
5. Compare the log of the write and flush request completion with the
one of the read and verify process.

SSDs that honor the flush request don't cause verify errors for blocks
where the write bio and the flush bio completed successfully. Those two
Intel SSDs that I mentioned failed this test. Other Intel SSD types
succeeded the test.

Maybe a firmware update would fix this issue, I suppose it will, I have
never tried it. My intention was not to blame the SSD manufacturer, in
fact, I like their SSDs very much and buy and use them frequently. I
just wanted to prevent Josef from the headache to question the Btrfs
implementation. The issue that Papp described looks just like a power
failure in conjunction with a storage device that ignores flush requests.

