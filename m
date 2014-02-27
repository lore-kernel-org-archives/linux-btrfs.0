Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34565 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0Utm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 15:49:42 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so1211516pab.6
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 12:49:41 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Help with space
From: otakujunction@gmail.com
In-Reply-To: <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com>
Date: Thu, 27 Feb 2014 14:49:40 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com> <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes it's an ancient 32 bit machine.  There must be a complex bug involved as the system, when originally mounted, claimed the correct free space and only as used over time did the discrepancy between used and free grow.  I'm afraid I chose btrfs because it appeared capable of breaking the 16 tera limit on a 32 bit system.  If this isn't the case then it's incredible that I've been using this file system for about a year without difficulty until now.

-Justin

Sent from my iPad

> On Feb 27, 2014, at 1:51 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> 
>> On Feb 27, 2014, at 12:27 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> This is on i686?
>> 
>> The kernel page cache is limited to 16TB on i686, so effectively your block device is limited to 16TB. While the file system successfully creates, I think it's a bug that the mount -t btrfs command is probably a btrfs bug.
> 
> Yes Chris, circular logic day. It's probably a btrfs bug that the mount command succeeds.
> 
> So let us know if this is i686 or x86_64, because if it's the former it's a bug that should get fixed.
> 
> 
> Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
