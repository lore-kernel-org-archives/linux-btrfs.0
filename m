Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:45296 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbaLESjT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 13:39:19 -0500
Message-ID: <5481FBD5.9040004@inwind.it>
Date: Fri, 05 Dec 2014 19:39:17 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <pan$67e00$edffae8a$cb013d3$4a1bb73d@cox.net>
In-Reply-To: <pan$67e00$edffae8a$cb013d3$4a1bb73d@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2014 08:26 AM, Duncan wrote:
> Goffredo Baroncelli posted on Thu, 04 Dec 2014 19:39:37 +0100 as
> excerpted:
> 
>> To check if a device is a LVM snapshot, it is checked the 'udev'
>> device property 'DM_UDEV_LOW_PRIORITY_FLAG' . If it is set to 1,
>> the device has to be skipped.
>>
>> As consequence, btrfs now depends also by the libudev.
> 
> Not being a coder I gotta ask...
> 
> How does this patch deal with mdev (busybox) or static dev instead of 
> udev?  Does it gracefully degrade to legacy LVM-agnostic behavior?

My patch no; of course we can put some #ifdef to make it an option.

[dropped the part related to systemd ....]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
