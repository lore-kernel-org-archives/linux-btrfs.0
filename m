Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4026 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751563AbdB1BY1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 20:24:27 -0500
Subject: Re: "parent transid verify failed" out of blue sky
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <30195f78-a741-7e51-338d-7b96b7a0fe4a@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a4aef000-1720-3dc5-ac39-ec8769376e93@cn.fujitsu.com>
Date: Tue, 28 Feb 2017 09:24:12 +0800
MIME-Version: 1.0
In-Reply-To: <30195f78-a741-7e51-338d-7b96b7a0fe4a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/28/2017 02:51 AM, Andrei Borzenkov wrote:
> This is VM under QEMU/KVM running openSUSE Tumbleweed. I boot it
> infrequently for short time to test something. Last time it installed
> quite a lot of updates including kernel (I think 4.9.11 was the last
> version); I do not remember whether I rebooted it after that. Today I
> booted it to check something, after 10 minutes did "reboot" and was
> greeted with grub rescue prompt (it is located on btrfs itself and
> apparently failed to read its modules as well). Any attempt to mount it
> fails with "parent transid verfy failed". btrfsck --mode=lowmem from
> current Tumbleweed snapshot runs for half an hour now with never-ending
> same message.

Would you please provide the size of the fs?

lowmem mode is indeed slow, as it doesn't use much memory so it will do 
tons of tree search instead, which will cause tons of same "parent 
transid verify failed" if the corrupted node/leaf lies in a hot tree, 
like root tree or extent tree.

Despite that, would you please try to run btrfsck original mode (default 
mode) on the fs?

It may takes some memory but it's more mature than lowmem mode.
In fact there are near 10 bug fixes for lowmem mode mode merged yet.

>
> I do not care in disk content really, but I would be interested in
> trying to recover it under guidance. Also if it may be useful I can
> provide image or other information.

Image would be best.
However I'm more interested how such problem happens.

In theory, Btrfs' mandatory metadata CoW and default data CoW should 
keep btrfs bullet proof to any powerloss.
(While real world is far from theory)

Thanks,
Qu

>
> TIA
>
> -andrei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


