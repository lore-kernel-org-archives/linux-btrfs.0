Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:32817 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcHKOrA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 10:47:00 -0400
Received: by mail-io0-f173.google.com with SMTP id 38so8161780iol.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 07:46:07 -0700 (PDT)
Subject: Re: checksum error in metadata node - best way to move root fs to new
 drive?
To: Nicholas D Steeves <nsteeves@gmail.com>, Dave T <davestechshop@gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
 <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
 <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
 <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
 <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <010942d8-aeca-f62f-2805-9d87c6ea802a@gmail.com>
Date: Thu, 11 Aug 2016 10:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-11 10:12, Nicholas D Steeves wrote:
> Why is the combination of dm-crypt|luks+btrfs+compress=lzo as
> overlooked as a potential cause?  Other than the "raid56 ate my data"
> I've noticed a bunch of "luks+btrfs+compress=lzo ate my data" threads.
I haven't personally seen one of those in at least a few months.  In 
general, BTRFS is moving fast enough that reports older than a kernel 
release cycle are generally out of date unless something confirms 
otherwise, but I do distinctly recall such issues being commonly 
reported in the past.
>
> On 10 August 2016 at 15:46, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>>
>> As far as dm-crypt goes, it looks like BTRFS is stable on top in the
>> configuration I use (aex-xts-plain64 with a long key using plain dm-crypt
>> instead of LUKS).  I have heard rumors of issues when using LUKS without
>> hardware acceleration, but I've never seen any conclusive proof, and what
>> little I've heard sounds more like it was just race conditions elsewhere
>> causing the issues.
>>
>
> Austin, I'm very curious if they were also using compress=lzo, because
> my informal hypothesis is that the encryption+btrfs+compress=lzo
> combination precipitates these issues.  Maybe the combo is more likely
> to trigger these race conditions?  It might also be neat to mine the
> archive to see these seem to be more likely to occur with fast SSDs vs
> slow rotational disks.  Do you use compress=lzo?
In my case, I've tested on both SSD's (both cheap low-end ones and good 
Intel and Crucial ones) and traditional hard drives, with and without 
compression (both zlib and lzo), and with a couple of different 
encryption algorithms (AES, Blowfish, and Threefish).  In my case It's 
only on plain dm-crypt, not LUKS, but I doubt that particular point will 
make much difference.  The last test I did was when the merge window for 
4.6 closed run as part of the regular regression testing I do, and I'll 
be doing another one in the near future.  I think the last time I saw 
any issues with this in my testing was prior to 4.0, but I don't 
remember for sure (most of what I care about is comparison to the 
previous version, so i don't keep much in the way of records of specific 
things).


