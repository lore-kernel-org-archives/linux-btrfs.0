Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward5j.cmail.yandex.net ([5.255.227.23]:49559 "EHLO
        forward5j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751507AbdBNBUP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 20:20:15 -0500
From: Alexander Tomokhov <alexoundos@ya.ru>
To: Roman Mamedov <rm@romanrm.net>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <20170206045421.02e18d70@natsu>
References: <14453691486330921@web21h.yandex.ru>
        <0dbbe15a-59f7-ef0e-1ed6-83fec7ef165a@mendix.com> <20170206045421.02e18d70@natsu>
Subject: Re: Is it possible to have metadata-only device with no data?
MIME-Version: 1.0
Message-Id: <2404821487035212@web23o.yandex.ru>
Date: Tue, 14 Feb 2017 04:20:12 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you. Interesting.
At least it's possible to implement in theory.
Though, this way metadata-only device is still handled like a casual btrfs device and not distinguished separately from normal data+metadata devices.

06.02.2017, 02:54, "Roman Mamedov" <rm@romanrm.net>:
> On Sun, 5 Feb 2017 22:55:42 +0100
> Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:
>
>>  On 02/05/2017 10:42 PM, Alexander Tomokhov wrote:
>>  > Is it possible, having two drives to do raid1 for metadata but keep data on a single drive only?
>>
>>  Nope.
>>
>>  Would be a really nice feature though... Putting metadata on SSD and
>>  bulk data on HDD...
>
> You can play around with this hack just to see how that would perform, but it
> comes with no warranty and untested even by me. I was going to try it, but put
> it on hold since you'd also need to make sure the SSD is being preferred for
> metadata reads (and not HDD), but so far have not figured out a simple way of
> ensuring that.
>
> --- linux-amd64-4.4/fs/btrfs/volumes.c.orig 2016-11-01 22:41:41.970978721 +0500
> +++ linux-amd64-4.4/fs/btrfs/volumes.c 2016-11-01 22:58:45.958977731 +0500
> @@ -4597,6 +4597,14 @@
>                  if (total_avail == 0)
>                          continue;
>
> + /* If we have two devices and one is less than 25% of the total FS size, then
> + * presumably it's a small device just for metadata RAID1, don't use it
> + * for new data chunks. */
> + if ((fs_devices->num_devices == 2) &&
> + (device->total_bytes * 4 < fs_devices->total_rw_bytes) &&
> + (type & BTRFS_BLOCK_GROUP_DATA))
> + continue;
> +
>                  ret = find_free_dev_extent(trans, device,
>                                             max_stripe_size * dev_stripes,
>                                             &dev_offset, &max_avail);
>
> --
> With respect,
> Roman
