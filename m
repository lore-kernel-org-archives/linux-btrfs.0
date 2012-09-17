Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43991 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab2IQRTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 13:19:37 -0400
Date: Mon, 17 Sep 2012 13:19:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Kay Sievers <kay@vrfy.org>
CC: btrfs <linux-btrfs@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: 'umount' of multi-device volume hangs until the device is
 physically un-plugged
Message-ID: <20120917171934.GD3143@localhost.localdomain>
References: <CAPXgP104Cc1q6+TkG6R1VzbqxqMBrMWJfF6X6VYpWPkg8jyK=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAPXgP104Cc1q6+TkG6R1VzbqxqMBrMWJfF6X6VYpWPkg8jyK=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2012 at 10:07:39PM -0600, Kay Sievers wrote:
> I'm currently playing around with native btrfs multi-device support in
> systemd. There might be a few "hotplug issues" to solve, here is the
> first one:
> 
> A mounted (otherwise unused) multi-device volume (USB multi-slot card
> reader), hangs at:
>   $ umount /mnt
> with (fedora) kernel
>   3.6.0-0.rc5.git0.1.fc18.x86_64
> 
> Any idea what to look for or what to try?
> 

Can I see the whole sysrq+w?  Also can you try btrfs-next and see if you have
the same problems?  Thanks,

Josef
