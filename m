Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34753 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbcFCSKf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 14:10:35 -0400
Received: by mail-io0-f180.google.com with SMTP id p194so82265165iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 11:10:35 -0700 (PDT)
Received: from static-215-186.vpn.wisc.edu (static-215-186.vpn.wisc.edu. [146.151.215.186])
        by smtp.gmail.com with ESMTPSA id v62sm311086itc.19.2016.06.03.11.10.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jun 2016 11:10:34 -0700 (PDT)
Message-ID: <1464977432.1571.20.camel@gmail.com>
Subject: RAID1 vs RAID10 and best way to set up 6 disks
From: Mitchell Fossen <msfossen@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 03 Jun 2016 13:10:32 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have 6 WD Red Pro drives, each 6TB in space. My question is, what is
the best way to set these up? 

The system drive (and root) are on a 500GB SSD, so these drives will
only be used for /home and file storage.

Is there any caveats between RAID1 on all 6 vs RAID10?

Thanks for the help,

Mitch
