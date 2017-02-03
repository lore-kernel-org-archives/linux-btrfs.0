Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:49570
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbdBCKpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 05:45:17 -0500
Received: from [117.207.102.174] (port=47778 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1cZbLj-0005ln-Of
        for linux-btrfs@vger.kernel.org; Fri, 03 Feb 2017 03:44:16 -0700
Date: Fri, 3 Feb 2017 16:14:06 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: How to dump/find parity of RAID-5 file?
Message-ID: <20170203104406.GA3670@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Came across this thread https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg55161.html 
Exploring possibility of adding test-scripts around these area using dump-tree & corrupt-block.But
unable to figure-out how to get parity of file or find its location.  dump-tree output gave,

    item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 145096704) itemoff 15557 itemsize 144
        length 134217728 owner 2 stripe_len 65536 type DATA|RAID5
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 3 sub_stripes 0
            stripe 0 devid 3 offset 63111168                 # Is this parity?Seems empty?
            dev_uuid f62df114-186c-4e48-8152-9ed15aa078b4
            stripe 1 devid 2 offset 63111168                 # Contains file data-stripe-1
            dev_uuid c0aeaab0-e57e-4f7a-9356-db1878876d9f
            stripe 2 devid 1 offset 83034112                 # Contains file data-stripe-2
            dev_uuid 637b3666-9d8f-4ec4-9969-53b0b933b9b1
thanks.

Cheers.
Lakshmipathi.G
