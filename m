Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44089 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752232AbaBKCXq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 21:23:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>
Date: Mon, 10 Feb 2014 19:23:43 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name> <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com> <52F73E2B.9080103@friedels.name> <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 10, 2014, at 6:45 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Feb 9, 2014, at 1:36 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
>> 
>> Yes, but I can create that space.
>> So, for me the next steps would be to:
>> -generate enough room on the filesystem
>> -btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/BTRFS/Video
>> -btrfs device delete /dev/sdc1 /mnt/BTRFS/Video
>> 
>> Right?
> 
> No. You said you need to recreate the file system, and only have these two devices and therefore must remove one device. You can't achieve that with raid1 which requires minimum two devices.
> 
> -dconvert=single -mconvert=dup -sconvert=dup

Actually, I'm reminded with multiple devices that dup might not be possible. Instead you might have to using single for all of them. Then remove the device you want removed. And then do another conversion for just -mconvert=dup -sconvert=dup, and do not specify -dconvert. That way the single metadata profile is converted to duplicate.


Chris