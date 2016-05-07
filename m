Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:37678 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbcEGQLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 12:11:52 -0400
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram  and disk are ok. it still mounts, but I cannot repair
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 07 May 2016 18:11:50 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Clemens Eisserer <linuxhippy@gmail.com>
In-Reply-To: <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
Message-ID: <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il 2016-05-07 17:58 Clemens Eisserer ha scritto:
> Hi Niccolo,
> 
>> btrfs + dmcrypt + compress=lzo + autodefrag = corruption at first boot
> 
> Just to be curious - couldn't it be a hardware issue? I use almost the
> same setup (compress-force=lzo instead of compress-force=lzo) on my
> laptop for 2-3 years and haven't experienced any issues since
> ~kernel-3.14 or so.
> 
> Br, Clemens Eisserer

Hi,
Which kind of hardware issue? I did a full memtest86 check, a full 
smartmontools extended check and even a badblocks -wsv.
If this is really an hardware issue that we can identify I would be more 
than happy because Dell will replace my laptop and this nightmare will 
be finally over. I'm open to suggestions.

Niccolò
