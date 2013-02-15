Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64758 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161288Ab3BOOz1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 09:55:27 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so1261414wid.12
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 06:55:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r0TW6oaHcASw7tujExyfpQbr-D-ahe01ff0+oo8m1qwjA@mail.gmail.com>
References: <CAOcd+r0TW6oaHcASw7tujExyfpQbr-D-ahe01ff0+oo8m1qwjA@mail.gmail.com>
Date: Fri, 15 Feb 2013 16:55:26 +0200
Message-ID: <CAOcd+r2vYVLrPCRFGjTsfECtsqHi-LyPON7Ezsna3XGD0C=vHg@mail.gmail.com>
Subject: Re: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents
 when possible V3
From: Alex Lyakas <alex@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
is there still an issue with applying the patch?

Thanks,
Alex.


On Mon, Jan 28, 2013 at 7:01 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> These two patches address the issue of sending unneeded zero data for
> disknr==0 and PREALLOC extents.
> There is room for additional improvement for PREALLOC extents, but it
> requires adding a new send command, so for now this is not addressed.
>
> Changes in V2: no functional change; previous patchset was malformed,
> so cleanup done with checkpatch.pl.
> Changes in V3: rebased against btrfs-next
>
> Alex Lyakas (2):
>   Avoid sending disknr==0 extents when possible.
>   On a diff-send, avoid sending PREALLOC extents, if the     parent
>     root has only PREALLOC extents on an appropriate     file range.
>
>  fs/btrfs/send.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 178 insertions(+), 6 deletions(-)
>
> --
> 1.7.9.5
