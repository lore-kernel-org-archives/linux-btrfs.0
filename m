Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:53558 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeDPBqL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 21:46:11 -0400
Received: by mail-it0-f45.google.com with SMTP id m134-v6so9495231itb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 18:46:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRknKH5_J83b0h9SHzGELbSKFYzjkyz9-gH8vk-sV4w=w@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
 <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com>
 <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com>
 <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com> <CAJCQCtRknKH5_J83b0h9SHzGELbSKFYzjkyz9-gH8vk-sV4w=w@mail.gmail.com>
From: Alexander Zapatka <alexzapatka@gmail.com>
Date: Sun, 15 Apr 2018 21:45:50 -0400
Message-ID: <CAFd7XodEGFDaR6XFr2i1t4CzmogkofQogzFGLNM7cWB2EifEyg@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

thanks, Chris.  i have given a timeout of 300 to all the drives.  they
are all USB, all connected to an apollo lake based htpc.  then i
started the command again... the dmesg output is here from a few
minutes after i started the btrfs device remove command.
https://paste.ee/p/H1R0i.  no hopes, high or low, but i'm still
getting the same errors.  i'll let it run though the night tho, as it
doesn't seem to hurt anything other then slowly lock the system up.

on a side note, all the USB drives are either powered or are connected
to a powered hub..  thanks again!

On Sun, Apr 15, 2018 at 8:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Apr 15, 2018 at 6:30 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> # echo value > /sys/block/device-name/device/timeout
>>
>
> Also note that this is not a persistent setting. It needs to be done
> per boot. But before you change it, use cat to find out what the value
> is. Default is 30.
>
> I'm seeing this:
> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec
>
> Which could bmaybe be adapted from mdadm raid to look for Btrfs
> instead, or in addition to.
>
> --
> Chris Murphy



-- 
 -o)
  /\\    Message void if penguin violated
_\_V    Don't mess with the penguin
