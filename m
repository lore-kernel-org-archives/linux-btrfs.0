Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:34590 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3IYNAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 09:00:49 -0400
Received: by mail-la0-f50.google.com with SMTP id gx14so4796595lab.23
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 06:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A06B4AF5-710F-44F9-B793-1F417A99BF72@colorremedies.com>
References: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com>
	<A06B4AF5-710F-44F9-B793-1F417A99BF72@colorremedies.com>
Date: Wed, 25 Sep 2013 18:30:39 +0530
Message-ID: <CALe5EmwjQowFK9aggAV5LQjK1FhYM13StutosGjLkd0giwvmAA@mail.gmail.com>
Subject: Re: hi
From: vgrvelu <vgrajan2005@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

after doing mofprobe btrfs I could see btrfs entry in proc file
system. But still mount command is failing. It looks like super block
is corrupted

thanks
rajan

On Wed, Sep 25, 2013 at 5:26 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sep 24, 2013, at 5:39 PM, vgrvelu <vgrajan2005@gmail.com> wrote:
>
>> hi
>>
>> I created  btrfs file system  on one of  sda partition. when I mount
>> with mount -t /dev/sda17  /btrfs,
>
> remove the -t or add btrfs after it.
>
>
>
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
A.V.Gomathirajan
M.S Research (Entrepreneurship)
Indian Institute of Technology Madras
