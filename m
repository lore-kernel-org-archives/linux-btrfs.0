Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:34672 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752652AbeDPAwt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 20:52:49 -0400
Received: by mail-ot0-f169.google.com with SMTP id i5-v6so6129011oth.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 17:52:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
 <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com>
 <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com> <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 18:52:47 -0600
Message-ID: <CAJCQCtRknKH5_J83b0h9SHzGELbSKFYzjkyz9-gH8vk-sV4w=w@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Chris Murphy <lists@colorremedies.com>
Cc: Alexander Zapatka <alexzapatka@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2018 at 6:30 PM, Chris Murphy <lists@colorremedies.com> wrote:

> # echo value > /sys/block/device-name/device/timeout
>

Also note that this is not a persistent setting. It needs to be done
per boot. But before you change it, use cat to find out what the value
is. Default is 30.

I'm seeing this:
https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec

Which could bmaybe be adapted from mdadm raid to look for Btrfs
instead, or in addition to.

-- 
Chris Murphy
