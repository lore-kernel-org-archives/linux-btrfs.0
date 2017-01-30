Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:58932
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753026AbdA3MrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 07:47:25 -0500
Received: from mail-ua0-f175.google.com ([209.85.217.175]:34946)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1cYBDK-0006UN-Nh
        for linux-btrfs@vger.kernel.org; Mon, 30 Jan 2017 05:37:42 -0700
Received: by mail-ua0-f175.google.com with SMTP id y9so250112118uae.2
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 04:37:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <006ecc84-52fb-2b09-0e47-317fa018e9f9@mendix.com>
References: <20170130015416.GA5619@giis.co.in> <006ecc84-52fb-2b09-0e47-317fa018e9f9@mendix.com>
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Date: Mon, 30 Jan 2017 18:07:01 +0530
Message-ID: <CAKuJGC_x8S-RhnXA+1oVL3zsDkjMaHxixgajxmxvuRw6BZNUHA@mail.gmail.com>
Subject: Re: Fresh Raid-1 setup, dump-tree shows invalid owner id
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Yes, the owner is the number of the tree.
>
> DATA_RELOC_TREE is -9, but then unsigned 64 bits.
>
>>>> -9 + 2**64
> 18446744073709551607L
>
> So the result is a number that's close to the max or 64 bits.
>
> You can find those numbers in the kernel source in
>   include/uapi/linux/btrfs_tree.h
>
> e.g.:
>
> #define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL
>

Thanks for the details. This owner number looked different from other
owner ids, so wanted to check on the same, now understood.

Cheers.
Lakshmipathi.G
