Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 1.mo173.mail-out.ovh.net ([178.33.111.180]:38642 "EHLO
        1.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933553AbdERK7q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 06:59:46 -0400
Received: from player739.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 063843F7D6
        for <linux-btrfs@vger.kernel.org>; Thu, 18 May 2017 09:22:58 +0200 (CEST)
Subject: Re: Can't remount a BTRFS partition read write after a drive failure
To: "Ivan Sizov <sivan606@gmail.com>;Chris Murphy"
        <lists@colorremedies.com>
References: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
 <CAMG9ccz555xia-FpqGsoy-uzYXcyYwG6H0EC18O2AC9yLUuBpg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Sylvain Leroux <sylvain@chicoree.fr>
Message-ID: <d76bbe8f-af4a-36a0-2eb0-45384a8fee79@chicoree.fr>
Date: Thu, 18 May 2017 09:22:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAMG9ccz555xia-FpqGsoy-uzYXcyYwG6H0EC18O2AC9yLUuBpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/2017 09:19 AM, Ivan Sizov wrote:
> > The drive is not reliable. And I noticed when there is an error and the
> > USB device appears to be dead to the kernel, I am later unable to
> > remount rw the drive. I can mount it read only though.
> > This seems to be a systematic behavior. And it occasionally happens when
> > the computer wake up from sleep and the drive is still attached.
> > Power cycling the disk do not change anything, but restarting the
> > computer "solves" the issue.
>
> (Maybe offtop) Seems like your disk's USB-SATA controller is almost
dead. You shouldn't further use it with USB because this lead to data
corruption. Detach HDD from case and plug directly to a SATA port or
replace the controller.


Thank you Chris, Ivan, for your answers.

I understand the drive appears dead to the kernel and the safest
solution is to mount back the drive read only.

But...

To give you more details about my particular use case, we are
investigating the resilience of various FS to hardware failures. The
disk is (presumably) working but we are using a modified USB cable to
produce bus errors on purpose.

If I understand it well, when we switch the cable to "faulty mode", the
kernels detects usb errors or something, consider the device as dead,
and try to reset the bus. On that event, the drive will remount ro.

However, when we switch back the cable to "Normal mode", we are unable
to forcefully remount the drive rw. Even if we replace our cable by a
genuine one, and/or if we power cycle the drive. BTRFS just refuse to
remount rw that drive. FWIW, BTRFS is the only filesystems we've tested
considering a faulty drive as _definitively_ faulty without any hope for
the administrator to override that.


Here we are in a very special use case. But I think we would see a
similar behavior if some drive case or cable was dying, the
administrator replaced it, but was unable to remount rw the drive after
having fixed the problem. Or did I missed something?


-- 
-- Sylvain Leroux
-- sylvain@chicoree.fr
-- http://www.chicoree.fr


