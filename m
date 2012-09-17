Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48116 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2IQWRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 18:17:53 -0400
Received: by bkwj10 with SMTP id j10so2797556bkw.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 15:17:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120917171934.GD3143@localhost.localdomain>
References: <CAPXgP104Cc1q6+TkG6R1VzbqxqMBrMWJfF6X6VYpWPkg8jyK=g@mail.gmail.com>
 <20120917171934.GD3143@localhost.localdomain>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 18 Sep 2012 00:17:31 +0200
Message-ID: <CAPXgP12kFY=0vgFjSH9WLa8dg_dg2WHP6+dEui+sAJK1cRcA0g@mail.gmail.com>
Subject: Re: 'umount' of multi-device volume hangs until the device is
 physically un-plugged
To: Josef Bacik <jbacik@fusionio.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 7:19 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Sun, Sep 16, 2012 at 10:07:39PM -0600, Kay Sievers wrote:
>> I'm currently playing around with native btrfs multi-device support in
>> systemd. There might be a few "hotplug issues" to solve, here is the
>> first one:
>>
>> A mounted (otherwise unused) multi-device volume (USB multi-slot card
>> reader), hangs at:
>>   $ umount /mnt
>> with (fedora) kernel
>>   3.6.0-0.rc5.git0.1.fc18.x86_64
>>
>> Any idea what to look for or what to try?
>>
> Can I see the whole sysrq+w?  Also can you try btrfs-next and see if you have
> the same problems?  Thanks,

Hmm, I can't reproduce that today. Nothing really has changes with the
setup. It was easy to reproduce yesterday, even across multiple
reboots.

I'll come back if I see it again. Thanks,
Kay
