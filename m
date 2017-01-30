Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:51626
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbdA3LhC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 06:37:02 -0500
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33417)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1cYAF0-0004dU-KS
        for linux-btrfs@vger.kernel.org; Mon, 30 Jan 2017 04:35:22 -0700
Received: by mail-ua0-f181.google.com with SMTP id i68so247260503uad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 03:35:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170130015416.GA5619@giis.co.in>
References: <20170130015416.GA5619@giis.co.in>
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Date: Mon, 30 Jan 2017 17:04:41 +0530
Message-ID: <CAKuJGC-dGqqH5YfZ5tezVdkcOtAMfYgsQuD+-_AW8OSmbJSkxw@mail.gmail.com>
Subject: Re: Fresh Raid-1 setup, dump-tree shows invalid owner id
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid1 is irrelevant, looks like this happen with simple case too.
$./mkfs.btrfs tests/test.img
$./btrfs-debug-tree tests/test.img

possible issue with ./btrfs-debug-tree stdout?

On Mon, Jan 30, 2017 at 7:24 AM, Lakshmipathi.G
<lakshmipathi.g@giis.co.in> wrote:
> After creating raid1:
> $./mkfs.btrfs -f -d raid1 -m raid1 /dev/sda6 /dev/sda7
>
> and using
> $./btrfs inspect-internal dump-tree /dev/sda6  #./btrfs-debug-tree /dev/sda6
>
> shows possible wrong value for 'owner'?
> --
> checksum tree key (CSUM_TREE ROOT_ITEM 0)
> leaf 29425664 items 0 free space 16283 generation 4 owner 7
> fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
> chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0)
> leaf 29442048 items 2 free space 16061 generation 4 owner 18446744073709551607 <<< owner id?
> fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
> chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
> --
>
> or is that expected output?
>
> Cheers.
> Lakshmipathi.G
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
