Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36815 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbdEQPV4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:21:56 -0400
Received: by mail-wm0-f51.google.com with SMTP id 70so14235124wmq.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 08:21:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
References: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
From: Ivan Sizov <sivan606@gmail.com>
Date: Wed, 17 May 2017 18:21:34 +0300
Message-ID: <CAMG9cczmSVJLzxSC6t+ayVcGm=qPdT6ALAm9YAMQbtsqKbAneg@mail.gmail.com>
Subject: Re: Can't remount a BTRFS partition read write after a drive failure
To: Sylvain Leroux <sylvain@chicoree.fr>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-16 15:56 GMT+03:00 Sylvain Leroux <sylvain@chicoree.fr>:
>
>
> The drive is not reliable. And I noticed when there is an error and the
> USB device appears to be dead to the kernel, I am later unable to
> remount rw the drive. I can mount it read only though.
>
> This seems to be a systematic behavior. And it occasionally happens when
> the computer wake up from sleep and the drive is still attached.
>
> Power cycling the disk do not change anything, but restarting the
> computer "solves" the issue.

(Maybe offtop) Seems like your disk's USB-SATA controller is almost
dead. You shouldn't further use it with USB because this lead to data
corruption. Detach HDD from case and plug directly to a SATA port or
replace the controller.

--
Ivan Sizov
