Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37655 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751422AbcDRHWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 03:22:32 -0400
Subject: Re: Question: raid1 behaviour on failure
To: Matthias Bodenbinder <matthias@bodenbinder.de>,
        <linux-btrfs@vger.kernel.org>
References: <nf1q0j$ug4$1@ger.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57148B2E.6010904@cn.fujitsu.com>
Date: Mon, 18 Apr 2016 15:22:22 +0800
MIME-Version: 1.0
In-Reply-To: <nf1q0j$ug4$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not quite sure about raid1 behavior.

But your "hotplug" seems to be problem.
IIRC Btrfs is known to have problem with re-appearing device.

If the hot revmoed device is fully wiped before re-plugged, it should 
not cause the RO mount (abort transaction).

BTW, it would be better to post the dmesg for better debug.

Hopes other one could give better explanation on this.

Thanks,
Qu

Matthias Bodenbinder wrote on 2016/04/18 07:06 +0200:
> Hi,
>
> I have a raid1 with 3 drives: 698, 465 and 232 GB. I copied 1,7 GB data to that raid1, balanced the filesystem and then removed the bigger drive (hotplug).
>
> The data was still available. Now I copied the /root directory to the raid1. It showed up via ls -l. Then I plugged in the missing hard drive again (hotplug). After a few seconds "btrfs fi show" is giving output as usual:
>
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
> 	Total devices 3 FS bytes used 1.60GiB
> 	devid    1 size 698.64GiB used 4.03GiB path /dev/sdg
> 	devid    2 size 465.76GiB used 4.03GiB path /dev/sdh
> 	devid    3 size 232.88GiB used 0.00B path /dev/sdi
>
> The /root is still showing up, but the raid1 is now mounted in *read-only* mode.
>
> I umounted it and mounted it again. Now the /root directory on the raid1 is no longer available. Its gone.
>
> I guess I missed some important step to recover the degraded raid1 before umounting it.
>
> What is it that I missed?
>
> Matthias
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


