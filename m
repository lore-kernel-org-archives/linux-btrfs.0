Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64377 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3IYNvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 09:51:24 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so6111069pdj.31
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 06:51:23 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: hi
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CALe5EmwjQowFK9aggAV5LQjK1FhYM13StutosGjLkd0giwvmAA@mail.gmail.com>
Date: Wed, 25 Sep 2013 21:51:17 +0800
Cc: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Message-Id: <9814C718-C5B2-405D-82DC-7EDAFE823665@gmail.com>
References: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com> <A06B4AF5-710F-44F9-B793-1F417A99BF72@colorremedies.com> <CALe5EmwjQowFK9aggAV5LQjK1FhYM13StutosGjLkd0giwvmAA@mail.gmail.com>
To: vgrvelu <vgrajan2005@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Hi
> 
> after doing mofprobe btrfs I could see btrfs entry in proc file
> system. But still mount command is failing. It looks like super block
> is corrupted

You can try to recover superblocks.

Steps:

#git clone http://github.com/kdave/btrfs-progs.git 
# cd btrfs-progs
# git pull http://github.com/kdave/btrfs-progs.git  integration-20130924
# make && make install
# btrfs rescue super-recover -vy <device>


Let's see what will happen..

Thanks,
Wang
> 
> thanks
> rajan
> 
> On Wed, Sep 25, 2013 at 5:26 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>> On Sep 24, 2013, at 5:39 PM, vgrvelu <vgrajan2005@gmail.com> wrote:
>> 
>>> hi
>>> 
>>> I created  btrfs file system  on one of  sda partition. when I mount
>>> with mount -t /dev/sda17  /btrfs,
>> 
>> remove the -t or add btrfs after it.
>> 
>> 
>> 
>> Chris Murphy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> A.V.Gomathirajan
> M.S Research (Entrepreneurship)
> Indian Institute of Technology Madras
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

