Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35700 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbcGOPKt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 11:10:49 -0400
Received: by mail-lf0-f53.google.com with SMTP id f93so90489630lfi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 08:10:48 -0700 (PDT)
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5:
 take two
To: Chris Mason <clm@fb.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <a0538df6-7e25-fae8-8ebd-b18120a1c516@fb.com> <578868EE.2030108@gmail.com>
 <2af4a9cc-bf09-680c-1743-530e521677b2@fb.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5788FCF4.2010908@gmail.com>
Date: Fri, 15 Jul 2016 18:10:44 +0300
MIME-Version: 1.0
In-Reply-To: <2af4a9cc-bf09-680c-1743-530e521677b2@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.07.2016 16:20, Chris Mason пишет:
>>>
>>> Interesting, thanks for taking the time to write this up.  Is the
>>> failure specific to scrub?  Or is parity rebuild in general also failing
>>> in this case?
>>>
>>
>> How do you rebuild parity without scrub as long as all devices appear to
>> be present?
> 
> If one block is corrupted, the crcs will fail and the kernel will
> rebuild parity when you read the file.  You can also use balance instead
> of scrub.
> 

As we have seen recently, btrfs does not compute, stores or verifies
checksum of RAID56 parity. So if parity is corrupted, the only way to
detect and correct it is to use scrub. Balance may work by side effect,
because it simply recomputes parity on new data, but it will not fix
wrong parity on existing data.

I agree that if data block is corrupted it will be detected, but then
you do not need to recompute parity in the first place.
