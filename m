Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35264 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbcEUCbq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 22:31:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3whc-0008KT-7d
	for linux-btrfs@vger.kernel.org; Sat, 21 May 2016 04:31:44 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 May 2016 04:31:44 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 May 2016 04:31:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs restore fails because of NO SPACE
Date: Sat, 21 May 2016 02:31:36 +0000 (UTC)
Message-ID: <pan$60140$c7109ea3$9788fa1f$d541b797@cox.net>
References: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
	<CAJCQCtSh-OqADqPZU1s8HjbvOBmoGB+swHNAS3FanQr5WQoyzw@mail.gmail.com>
	<1D45DF48-1D90-42AA-9F4F-70931A655F6D@me.com>
	<CAJCQCtSbLVrU-OLa8hr6P2zgwz9-8qoV3tqjC5WM0KCnneDptA@mail.gmail.com>
	<428B0808-F5BD-4B29-BF6C-C2F3188C0F9A@me.com>
	<CAJCQCtRk7scbGRqtfWMf-jyV4vq3wDEEKVi+SmtzzDKSj_+NRw@mail.gmail.com>
	<D3BB243E-5F60-4633-9966-398E0A0F5329@me.com>
	<CAJCQCtS0b9Boh6VwGgXTh38f0tJqGWjTh2SMRUkYUtCwW3PSpQ@mail.gmail.com>
	<CAJCQCtQrr47GtJAxgQ79ECfuU2NTnGR65HZc8QH+z6poHk62wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 20 May 2016 15:53:07 -0600 as excerpted:

>>btrfs fi show Label: none  uuid: 93000933-e46d-403b-80d7-60475855e3f3
>>         Total devices 2 FS bytes used 2.56TiB
>>         devid    1 size 2.73TiB used 2.71TiB path /dev/sda
>>         devid    4 size 2.73TiB used 2.71TiB path /dev/sdb
> 
> 
> OK so why does it only list two devices? This is a three drive or four
> drive raid10? This is Btrfs raid10 specifically? I'm confused now about
> the setup and why btrfs fi show isn't saying there are missing devices,
> there is no such thing as two drive btrfs raid10.

I'm confused about where you got that it was a raid10?  I don't see it in 
anything he posted, that got here to gmane, at least.  In fact, I see 
only his initial thread-root post, and it doesn't mention raid10 at all 
that I can see.

So given that fi show says two devices, none missing, I'd say it can't be 
a raid10, and further, given that he didn't specify the raid type, the 
btrfs default for a two-device btrfs must be assumed, which is raid1 
system and metadata, single mode data.

But I think that's beside the point in terms of the original question.  I 
think the problem is with his understanding of restore.  See the reply 
directly to his post, that I'll be making after this one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

