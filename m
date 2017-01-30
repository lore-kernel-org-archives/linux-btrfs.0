Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:37902
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdA3Bz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 20:55:28 -0500
Received: from [117.207.97.46] (port=55824 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1cY1Ao-0005Ee-8n
        for linux-btrfs@vger.kernel.org; Sun, 29 Jan 2017 18:54:26 -0700
Date: Mon, 30 Jan 2017 07:24:16 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: Fresh Raid-1 setup, dump-tree shows invalid owner id
Message-ID: <20170130015416.GA5619@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After creating raid1:
$./mkfs.btrfs -f -d raid1 -m raid1 /dev/sda6 /dev/sda7

and using
$./btrfs inspect-internal dump-tree /dev/sda6  #./btrfs-debug-tree /dev/sda6

shows possible wrong value for 'owner'? 
--
checksum tree key (CSUM_TREE ROOT_ITEM 0) 
leaf 29425664 items 0 free space 16283 generation 4 owner 7
fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 
leaf 29442048 items 2 free space 16061 generation 4 owner 18446744073709551607 <<< owner id?
fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
--

or is that expected output?

Cheers.
Lakshmipathi.G
