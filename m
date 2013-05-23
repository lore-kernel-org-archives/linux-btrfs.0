Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33834 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758044Ab3EWTda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 15:33:30 -0400
Message-ID: <519E6F04.5000900@itwm.fraunhofer.de>
Date: Thu, 23 May 2013 21:33:24 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: raid6: rmw writes all the time?
References: <knl3ke$n7t$1@ger.gmane.org> <20130523131118.4907.45217@localhost.localdomain> <519E1821.5070507@itwm.fraunhofer.de> <20130523133418.4907.21116@localhost.localdomain>
In-Reply-To: <20130523133418.4907.21116@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2013 03:34 PM, Chris Mason wrote:
> Quoting Bernd Schubert (2013-05-23 09:22:41)
>> On 05/23/2013 03:11 PM, Chris Mason wrote:
>>> Quoting Bernd Schubert (2013-05-23 08:55:47)
>>>> Hi all,
>>>>
>>>> we got a new test system here and I just also tested btrfs raid6 on
>>>> that. Write performance is slightly lower than hw-raid (LSI megasas) and
>>>> md-raid6, but it probably would be much better than any of these two, if
>>>> it wouldn't read all the during the writes. Is this a known issue? This
>>>> is with linux-3.9.2.
>>>
>>> Hi Bernd,
>>>
>>> Any time you do a write smaller than a full stripe, we'll have to do a
>>> read/modify/write cycle to satisfy it.  This is true of md raid6 and the
>>> hw-raid as well, but their reads don't show up in vmstat (try iostat
>>> instead).
>>
>> Yeah, I know and I'm using iostat already. md raid6 does not do rmw, but 
>> does not fill the device queue, afaik it flushes the underlying devices 
>> quickly as it does not have barrier support - that is another topic, but 
>> was the reason why I started to test btrfs.
> 
> md should support barriers with recent kernels.  You might want to
> verify with blktrace that md raid6 isn't doing r/m/w.
> 
>>
>>>
>>> So the bigger question is where are your small writes coming from.  If
>>> they are metadata, you can use raid1 for the metadata.
>>
>> I used this command
>>
>> /tmp/mkfs.btrfs -L test2 -f -d raid6 -m raid10 /dev/sd[m-x]
> 
> Ok, the stripe size is 64KB, so you want to do IO in multiples of 64KB
> times the number of devices on the FS.  If you have 13 devices, that's
> 832K.

Actually I have 12 devices, but we have to subtract 2 parity disks. In
the mean time I also patched btrfsprogs to use a chunksize of 256K. So
that should be 2560kiB now if I found the right places.
Btw, any chance to generally use chunksize/chunklen instead of stripe,
such as the md layer does it? IMHO it is less confusing to use
n-datadisks * chunksize = stripesize.

> 
> Using buffered writes makes it much more likely the VM will break up the
> IOs as they go down.  The btrfs writepages code does try to do full
> stripe IO, and it also caches stripes as the IO goes down.  But for
> buffered IO it is surprisingly hard to get a 100% hit rate on full
> stripe IO at larger stripe sizes.

I have not found that part yet, somehow it looks like as if writepages
would submit single pages to another layer. I'm going to look into it
again during the weekend. I can reserve the hardware that long, but I
think we first need to fix striped writes in general.

> 
>>
>> so meta-data should be raid10. And I'm using this iozone command:
>>
>>
>>> iozone -e -i0 -i1 -r1m -l 5 -u 5 -s20g -+n \
>>>         -F /data/fhgfs/storage/md126/testfile1 /data/fhgfs/storage/md126/testfile2 /data/fhgfs/storage/md126/testfile3 \
>>>            /data/fhgfs/storage/md127/testfile1 /data/fhgfs/storage/md127/testfile2 /data/fhgfs/storage/md127/testfile3
>>
>>
>> Higher IO sizes (e.g. -r16m) don't make a difference, it goes through 
>> the page cache anyway.
>> I'm not familiar with btrfs code at all, but maybe writepages() submits 
>> too small IOs?
>>
>> Hrmm, just wanted to try direct IO, but then just noticed it went into 
>> RO mode before already:
> 
> Direct IO will make it easier to get full stripe writes.  I thought I
> had fixed this abort, but it is just running out of space to write the
> inode cache.  For now, please just don't mount with the inode cache
> enabled, I'll send in a fix for the next rc.

Thanks, I already noticed and disabled the inode cache.

Direct-io works as expected and without any RMW cycles. And that
provides more than 40% better performance than the Megasas controller or
buffered MD writes (I didn't compare with direct-io MD, as that is very
slow).


Cheers,
Bernd

