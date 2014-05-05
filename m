Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:11801 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbaEEENj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 00:13:39 -0400
Message-ID: <53670FEA.8050806@swiftspirit.co.za>
Date: Mon, 05 May 2014 06:13:30 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
References: <20140504004732.GE9061@merlins.org> <5365E74B.6020805@swiftspirit.co.za> <20140505005644.GB10159@merlins.org>
In-Reply-To: <20140505005644.GB10159@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/05 02:56 AM, Marc MERLIN wrote:
> On Sun, May 04, 2014 at 09:07:55AM +0200, Brendan Hide wrote:
>> On 2014/05/04 02:47 AM, Marc MERLIN wrote:
>>> Is there any functional difference between
>>>
>>> mount -o subvol=usr /dev/sda1 /usr
>>> and
>>> mount /dev/sda1 /mnt/btrfs_pool
>>> mount -o bind /mnt/btrfs_pool/usr /usr
>>>
>>> ?
>>>
>>> Thanks,
>>> Marc
>> There are two "issues" with this.
>> 1) There will be a *very* small performance penalty (negligible, really)
> Oh, really, it's slower to mount the device directly? Not that I really
> care, but that's unexpected.

Um ... the penalty is if you're mounting indirectly. ;)
>   
>> 2) Old snapshots and other supposedly-hidden subvolumes will be
>> accessible under /mnt/btrfs_pool. This is a minor security concern
>> (which of course may not concern you, depending on your use-case).
>> There are a few similar minor security concerns - the
>> recently-highlighted issue with old snapshots is the potential that
>> old vulnerable binaries within a snapshot are still accessible
>> and/or executable.
> That's a fair point. I can of course make that mountpoint 0700, but it's
> a valid concern in some cases (not for me though).
>
> So thanks for confirming my understanding, it sounds like both are valid
> and if you're already mounting the main pool like I am, that's the
> easiest way.
>
> Thanks,
> Marc
All good. :)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

