Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54489 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbBFA2s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 19:28:48 -0500
Received: by mail-pa0-f41.google.com with SMTP id kq14so13451860pab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 16:28:47 -0800 (PST)
Received: from [10.0.0.11] (60-241-125-152.static.tpgi.com.au. [60.241.125.152])
        by mx.google.com with ESMTPSA id pm2sm6140273pbb.81.2015.02.05.16.28.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Feb 2015 16:28:46 -0800 (PST)
Message-ID: <54D40AB5.5000504@gmail.com>
Date: Fri, 06 Feb 2015 11:28:37 +1100
From: Zia Nayamuth <zedestructor@gmail.com>
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS EFI Boot question
References: <005001d0418a$e980a980$bc81fc80$@lksmith.net>
In-Reply-To: <005001d0418a$e980a980$bc81fc80$@lksmith.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unless you're putting the EFI System Partition (ESP) on the RAID10, you 
should be fine.

Note that the ESP also needs ot be FAT32, so you can't have it as a part 
of your btrfs RAID10 array, so if that's what you are asking, it can't 
be done. An ESP located somewhere else should still be able to boot from 
a rootfs in the RAID10 however, so your OS can be on the RAID.

-- 
Zia Nayamuth

On 6/02/2015 8:30 AM, Lucas Smith wrote:
> Hey folks!
>
> Having a confusing question brought up to me by my Debian Testing installer
> and am unsure what the implications are for it. I want to run btrfs in
> RAID10 on 4x1TB WD RE3 drives. Apparently, my system is set up to boot using
> EFI. Are there any reasons not to use EFI Booting in this circumstance?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

