Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward5m.cmail.yandex.net ([5.255.216.23]:42152 "EHLO
        forward5m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751494AbdBNBaO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 20:30:14 -0500
From: Alexander Tomokhov <alexoundos@ya.ru>
To: Kai Krakow <hurikhan77@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <20170205232721.165e96f3@jupiter.sol.kaishome.de>
References: <14453691486330921@web21h.yandex.ru> <20170205232721.165e96f3@jupiter.sol.kaishome.de>
Subject: Re: Is it possible to have metadata-only device with no data?
MIME-Version: 1.0
Message-Id: <1609461487035347@web31j.yandex.ru>
Date: Tue, 14 Feb 2017 04:22:27 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, thank you for suggestion. Bcache is what I actually use right now. However it's concept is different, operating at block/bucket level and requires another (underlying!) layer.

06.02.2017, 01:27, "Kai Krakow" <hurikhan77@gmail.com>:
> Am Mon, 06 Feb 2017 00:42:01 +0300
> schrieb Alexander Tomokhov <alexoundos@ya.ru>:
>
>>  Is it possible, having two drives to do raid1 for metadata but keep
>>  data on a single drive only? --
>
> No, but you could take a look into bcache which should get you
> something similar if used in write-around mode.
>
> Random access will become cached in bcache, which should most of the
> time be metadata, plus of course randomly accessed data from HDD. If
> you reduce the sequential cutoff trigger in bcache, it should cache
> mostly metadata only.
>
> --
> Regards,
> Kai
>
> Replies to list-only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
