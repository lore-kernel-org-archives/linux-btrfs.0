Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52931 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaGBM5M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 08:57:12 -0400
Received: by mail-pd0-f169.google.com with SMTP id g10so11884853pdj.14
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 05:57:11 -0700 (PDT)
Received: from mail2.smcindiaonline.com ([59.144.72.226])
        by mx.google.com with ESMTPSA id pz10sm37228960pbb.33.2014.07.02.05.57.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jul 2014 05:57:10 -0700 (PDT)
Date: Wed, 2 Jul 2014 18:27:04 +0530
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df <mount point> outputs info instead of error even
 when <mount-point> is just a directory
Message-ID: <20140702125704.GA26359@mail2.smcindiaonline.com>
References: <20140702051444.GA5459@mail2.smcindiaonline.com>
 <53B3A488.4030406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <53B3A488.4030406@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 02, 2014 at 02:19:52PM +0800, Qu Wenruo wrote:
>
>-------- Original Message --------
>Subject: btrfs fi df <mount point> outputs info instead of error even 
>when <mount-point> is just a directory
>From: Vikram Goyal <vikigoyal@gmail.com>
>To: linux-btrfs@vger.kernel.org
>Date: 2014年07月02日 13:14
>>Hi,

<snip>

>Although this should be fixed by checking whether the parameter is a 
>mountpoint.
>I'll also try to fix this too.
>>
>> [ivikram@localhost ~]# btrfs fi show
>> Label: 'fedora'  uuid: d2b3420c-99c1-44cc-a922-ac266072c7fb
>>         Total devices 2 FS bytes used 33.33GiB
>>         devid    2 size 73.51GiB used 44.03GiB path /dev/sdb6
>>         devid    3 size 73.30GiB used 44.03GiB path /dev/sda2
>>
>> Label: 'Vikram'  uuid: 0809b072-35f3-4866-92b8-af4772b23ed6
>>         Total devices 2 FS bytes used 109.68GiB
>>         devid    1 size 158.03GiB used 157.00GiB path /dev/dm-0
>>         devid    2 size 157.00GiB used 157.00GiB path /dev/mapper/sdb1
>>
>I'm very sorry that I did catch the point why 'btrfs fi show' is used 
>here and what's the problem.
>It would be very nice if you can explain what's wrong with 'btrfs fi show'.
>

Sorry for the confusion. It inadvertently got added. Please ignore the
same.

The mail was only in context to btrfs fi df. Many thanks for your
kind attention to this mail. Hope the change will help everybody.

Regards,

-- 
vikram...
         ||||||||
         ||||||||
^^'''''^^||root||^^^'''''''^^
        // \\   ))
       //(( \\// \\
      // /\\ ||   \\
     || / )) ((    \\
-- 
"If you are beginning to doubt what I am saying, you are
 probably hallucinating."
-- The Firesign Theatre, _Everything you know is Wrong_
-- 
  o
 ~|~
  =
