Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:35640 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbdBRLD1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Feb 2017 06:03:27 -0500
Received: by mail-ot0-f178.google.com with SMTP id 45so45671771otd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Feb 2017 03:03:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Sat, 18 Feb 2017 11:03:26 +0000
Message-ID: <CAMU1PDic=-vfw3VKtWNyT_3in5DMoEMLgE_SwK-eJ5hpRDgkXg@mail.gmail.com>
Subject: Re: [PATCH 0/7] cleanup __btrfs_map_block
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 February 2017 at 01:28, Liu Bo <bo.li.liu@oracle.com> wrote:
> This is attempting to make __btrfs_map_block less scary :)
>
> The major changes are
>
> 1) split operations for discard out of __btrfs_map_block and we don't copy
> discard operations for the target device of dev replace since they're not
> as important as writes.
>
> 2) put dev replace stuff into helpers since they're basically
> self-independant.

Just a note on English.  Self-independant / self-independent is a made
up word.  (Used in PATCH 0/7, 3/7 and 4/7).  I assume you intended to
use either self-contained or independent.

Thanks,
Mike
