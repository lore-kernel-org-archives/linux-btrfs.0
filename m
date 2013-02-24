Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37760 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab3BXAcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 19:32:05 -0500
Received: by mail-ob0-f180.google.com with SMTP id ef5so1739221obb.11
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2013 16:32:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <kgbgvv$qvr$1@ger.gmane.org>
References: <kgbgvv$qvr$1@ger.gmane.org>
Date: Sun, 24 Feb 2013 01:32:03 +0100
Message-ID: <CAMQ-g0dkx02n3Wd9bePxRpN7BF0h19vT3==yDN1kjqC0N-NNtQ@mail.gmail.com>
Subject: Re: Is my btrfs filesystem definitely dead?
From: Jan Steffens <jan.steffens@gmail.com>
To: =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 23, 2013 at 11:48 PM, Sébastien Luttringer <seblu@seblu.net> wrote:
> Trying to mount the FS i got a OOPS.
> # mount /dev/sdd2 /new_root
> [   60.602232] device label bitumefs devid 1 transid 40042 /dev/sdd2
> [   60.603629] btrfs: disk space caching is enabled
> [   60.615642] Btrfs detected SSD devices, enabling SSD mode
> [   60.769651] ------------[ cut here ]------------
> [   60.769709] kernel BUG at fs/btrfs/free-space-cache.c:1553!

The BUG_ON in question is this one:

        /*
         * We need to search for bits in this bitmap.  We could only cover some
         * of the extent in this bitmap thanks to how we add space, so we need
         * to search for as much as it as we can and clear that amount, and then
         * go searching for the next bit.
         */
        search_start = *offset;
        search_bytes = ctl->unit;
        search_bytes = min(search_bytes, end - search_start + 1);
        ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
        BUG_ON(ret < 0 || search_start != *offset); /* <-- 1553 */

        /* We may have found more bits than what we need */
        search_bytes = min(search_bytes, *bytes);

Since the bug happens during log replay, I expect btrfs-zero-log will
get the partition mountable again, albeit with some data loss.

However, if you can, make an image of the affected partition first, to
further help debug this.
