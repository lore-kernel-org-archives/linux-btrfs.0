Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:43884
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752662AbdBRCIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 21:08:25 -0500
Received: from [59.93.14.58] (port=59614 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1ceuQl-000569-BW
        for linux-btrfs@vger.kernel.org; Fri, 17 Feb 2017 19:07:24 -0700
Date: Sat, 18 Feb 2017 07:37:11 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: Large no.of extents for a single small file with a fresh RAID5 setup
Message-ID: <20170218020711.GA23608@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

With RAID5, using 3 loop-back devices each has 4GB. On a fresh setup, created a 2mb file.
While checking no.of extents,it shows like:

# ./btrfs-debugfs -f /mnt/file2m.txt 
(257 0): ram 110592 disk 145227776 disk_size 114688
(257 110592): ram 4096 disk 145461248 disk_size 4096
(257 114688): ram 114688 disk 145342464 disk_size 118784
(257 229376): ram 712704 disk 145620992 disk_size 716800
(257 942080): ram 4096 disk 145096704 disk_size 4096
(257 946176): ram 737280 disk 146407424 disk_size 741376
(257 1683456): ram 413696 disk 147193856 disk_size 413696
file: /mnt/file2m.txt extents 7 disk size 2113536 logical size 2097152 ratio 0.99

Is this expected behaviour? Is there any mount option to minimize no.of extents for
a smaller file?

Cheers.
Lakshmipathi.G
