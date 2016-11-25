Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:35068 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbcKYX4a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 18:56:30 -0500
Received: by mail-yw0-f181.google.com with SMTP id i145so73578250ywg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 15:56:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161125161712.1df4f7b6@natsu>
References: <a39949b5-abab-40a3-943e-818b6ca7106b@linuxsystems.it> <20161125161712.1df4f7b6@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 25 Nov 2016 16:56:28 -0700
Message-ID: <CAJCQCtQNpoYHkjYtiW6kd+CF0ic-qZWFRC1RHnSavj3ntUcFxg@mail.gmail.com>
Subject: Re: My system mounts the wrong btrfs partition, from the wrong disk!
To: Roman Mamedov <rm@romanrm.net>
Cc: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 4:17 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Fri, 25 Nov 2016 12:05:57 +0100
> Niccolò Belli <darkbasic@linuxsystems.it> wrote:
>
>> This is something pretty unbelievable, so I had to repeat it several times
>> before finding the courage to actually post it to the mailing list :)
>>
>> After dozens of data loss I don't trust my btrfs partition that much, so I
>> make a backup copy with dd weekly.
>
> https://btrfs.wiki.kernel.org/index.php/Gotchas#Block-level_copies_of_devices
>
> "don't make copies with dd."

Yeah.

In the user's defense, it's way overdue for the kernel to refuse to
mount without some override flag like XFS does. This behavior is just
plain user hostile right now, and Btrfs gets an extra ding because
it's supposed to be better: easier to admin and have better data
integrity. Basically this is Btrfs eating at least one, possibly both,
file systems at the same time without warning, and it's not good
enough to warn in the wiki.


-- 
Chris Murphy
