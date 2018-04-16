Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:46804 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeDPEe0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 00:34:26 -0400
Received: by mail-ot0-f182.google.com with SMTP id v64-v6so15951863otb.13
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 21:34:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRR=gDO3GcYm+wL08prEDhonZw_52+2_KouSgBmJdx4eg@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
 <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com>
 <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com>
 <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com>
 <CAJCQCtRknKH5_J83b0h9SHzGELbSKFYzjkyz9-gH8vk-sV4w=w@mail.gmail.com>
 <CAFd7XodEGFDaR6XFr2i1t4CzmogkofQogzFGLNM7cWB2EifEyg@mail.gmail.com> <CAJCQCtRR=gDO3GcYm+wL08prEDhonZw_52+2_KouSgBmJdx4eg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 22:34:25 -0600
Message-ID: <CAJCQCtT85-+VMsnDuvKe0h2e67kRAmn0Fh7GUf3sdCk=xuBo+A@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Chris Murphy <lists@colorremedies.com>
Cc: Alexander Zapatka <alexzapatka@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2018 at 10:33 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Apr 15, 2018 at 7:45 PM, Alexander Zapatka
> <alexzapatka@gmail.com> wrote:
>> thanks, Chris.  i have given a timeout of 300 to all the drives.  they
>> are all USB, all connected to an apollo lake based htpc.  then i
>> started the command again... the dmesg output is here from a few
>> minutes after i started the btrfs device remove command.
>> https://paste.ee/p/H1R0i.  no hopes, high or low, but i'm still
>> getting the same errors.  i'll let it run though the night tho, as it
>> doesn't seem to hurt anything other then slowly lock the system up.
>>
>> on a side note, all the USB drives are either powered or are connected
>> to a powered hub..  thanks again!
>
> That's 5 minutes. I'd say something is wrong/badly designed if it's
> not giving a clear error message inside of 1 minute but the
> manufacturers have apparently decided upwards of 180. I haven't heard
> of it taking longer than 180, but good grief.

Bad proof reading: That's 180 seconds.


-- 
Chris Murphy
