Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob10.myregisteredsite.com ([209.17.115.48]:50856 "EHLO
	atl4mhob10.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbaAJAqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 19:46:32 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.115])
	by atl4mhob10.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0A0kTno032348
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 19:46:29 -0500
Message-ID: <52CF4302.6020403@chinilu.com>
Date: Thu, 09 Jan 2014 16:46:58 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>	<20140109104247.GH15634@carfax.org.uk>	<3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com>	<BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl>	<75CB34F7-0BC3-47B7-8817-94F74BC5FD18@colorremedies.com>	<52CF2F9D.4080504@chinilu.com> <CAFvQSYRDbdDaJDAUVuUq9pqh+EryJO_=jZGjEEedSOVj71SS+g@mail.gmail.com>
In-Reply-To: <CAFvQSYRDbdDaJDAUVuUq9pqh+EryJO_=jZGjEEedSOVj71SS+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Clemens,

On 01/09/2014 04:08 PM, Clemens Eisserer wrote:
> Hi George,
>
>> I really suspect a lot of bad block issues can be avoided by monitoring
>> SMART data.  SMART is working very well for me with btrfs formatted drives.
>> SMART will detect when sectors silently fail and as those failures
>> accumulate, SMART will warn in an obvious way that the drive in question is
>> at end of life.  So I think the whole bad block issue should ideally be
>> handled at a lower level than filesystem with modern hard drives.
> At least my original request was about cheap flash media, where you
> don't have the luxury that you can "trust" the hardware behaving
> properly. In fact, it might be benefitial for a SD card to not report
> ECC errors - most likely the user won't notice a small glitch playing
> back music - but he definitively will when the smartphone reports read
> errors and stopping playback which will cause that card to be RMAd.
>
> Also, wouldn't your argument be also valid for checksums - why
> checksum in software, when in theory the drive + controllers should do
> it anyway ;)
>
> Regards, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
It would certainly be a vast improvement if flash media had some of the 
sanity checking capability that conventional media has, but to say that 
these sorts of problems with flash media are legendary would almost be 
an understatement.

As for checksums, I view them more as a tool to detect data decay as 
opposed to checking for failed writes.  Of course that data decay might 
well result in failed writes when btrfs scrub tries to correct it.  At 
that point I would prefer that the drive, even flash media type, would 
catch and resolve write failures.  If it doesn't happen at the hardware 
layer, according to how I understand Hugo's answer, btrfs, at least for 
now, is not capable of it.  I believe it is true that filesystems 
historically done bad blocking, but I do think it is moving now to the 
hardware layer which is probably the best place for it to be and the 
flash drive industry needs to solve this problem at the 
hardware/firmware level.  That is my opinion anyway.
