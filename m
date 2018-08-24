Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:52810
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbeHXINN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 04:13:13 -0400
Received: from [103.215.170.1] (port=12523 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1ft3lE-008nsl-Ow
        for linux-btrfs@vger.kernel.org; Thu, 23 Aug 2018 21:31:49 -0700
Date: Fri, 24 Aug 2018 10:01:39 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: dduper - Offline btrfs deduplication tool
Message-ID: <20180824043139.GA8263@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi -

dduper is an offline dedupe tool. Instead of reading whole file blocks and
computing checksum, It works by fetching checksum from BTRFS csum tree. This 
hugely improves the performance. 

dduper works like:
	- Read csum for given two files.
	- Find matching location.
	- Pass the location to ioctl_ficlonerange directly
  	  instead of ioctl_fideduperange

By default, dduper adds safty check to above steps by creating a 
backup reflink file and compares the md5sum after dedupe. 
If the backup file matches new deduped file, then backup file is 
removed. You can skip this check by passing --skip option. Here is 
sample cli usage [1] and quick demo [2]  

Some performance numbers: (with -skip option)

Dedupe two 1GB files with same  content - 1.2 seconds
Dedupe two 5GB files with same  content - 8.2 seconds
Dedupe two 10GB files with same  content - 13.8 seconds

dduper requires `btrfs inspect-internal dump-csum` command, you can use 
this branch [3] or apply patch by yourself [4] 

[1] https://gitlab.collabora.com/laks/btrfs-progs/blob/dump_csum/Documentation/dduper_usage.md
[2] http://giis.co.in/btrfs_dedupe.gif
[3] git clone https://gitlab.collabora.com/laks/btrfs-progs.git -b  dump_csum
[4] https://patchwork.kernel.org/patch/10540229/ 

Please remember its version-0.1, so test it out, if you plan to use dduper real data.
Let me know, if you have suggestions or feedback or bugs :)

Cheers.
Lakshmipathi.G
