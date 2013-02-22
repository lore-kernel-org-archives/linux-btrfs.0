Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57857 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BVRl0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:41:26 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so586237pab.31
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 09:41:26 -0800 (PST)
Message-ID: <5127ADC3.7090808@alumni.calpoly.edu>
Date: Fri, 22 Feb 2013 09:41:23 -0800
From: Mike Power <dodtsair@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: copy on write misconception
References: <5127A6C0.6080104@alumni.calpoly.edu> <20130222171604.GI14283@carfax.org.uk>
In-Reply-To: <20130222171604.GI14283@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/2013 09:16 AM, Hugo Mills wrote:
> On Fri, Feb 22, 2013 at 09:11:28AM -0800, Mike Power wrote:
>> I think I have a misconception of what copy on write in btrfs means
>> for individual files.
>>
>> I had originally thought that I could create a large file:
>> time dd if=/dev/zero of=10G bs=1G count=10
>> 10+0 records in
>> 10+0 records out
>> 10737418240 bytes (11 GB) copied, 100.071 s, 107 MB/s
>>
>> real    1m41.082s
>> user    0m0.000s
>> sys    0m7.792s
>>
>> Then if I copied this file no blocks would be copied until they are
>> written.  Hence the two files would use the same blocks underneath.
>> But specifically that copy would be fast.  Since it would only need
>> to write some metadata.  But when I copy the file:
>> time cp 10G 10G2
>>
>> real    3m38.790s
>> user    0m0.124s
>> sys    0m10.709s
>>
>> Oddly enough it actually takes longer then the initial file
>> creation.  So I am guessing that the long duration copy of the file
>> is expected and that is not one of the virtues of btrfs copy on
>> write.  Does that sound right?
>     You probably want cp --reflink=always, which makes a CoW copy of
> the file's metadata only. The resulting files have the semantics of
> two different files, but share their blocks until a part of one of
> them is modified (at which point, the modified blocks are no longer
> shared).
>
>     Hugo.
>
I see, and it works great:
time cp --reflink=always 10G 10G3

real    0m0.028s
user    0m0.000s
sys    0m0.000s

So from the user perspective I might say I want to opt out of this 
feature not optin.  I want all copies by all applications done as a copy 
on write.  But if my understanding is correct that is up to the 
application being called (in this case cp) and how it in turns makes 
calls to the system.

In short I can't remount the btrfs filesystem with some new args that 
says always copy on write files because that is what it already.

Mike Power
