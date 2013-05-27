Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52090 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab3E0Tif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 15:38:35 -0400
Received: by mail-ea0-f173.google.com with SMTP id n15so4106640ead.4
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 12:38:34 -0700 (PDT)
Received: from linux-suse.localnet (dsl51B6D2E0.pool.t-online.hu. [81.182.210.224])
        by mx.google.com with ESMTPSA id h49sm11294361eew.7.2013.05.27.12.38.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 27 May 2013 12:38:33 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Kernel BUG at ctree.c:1144 and soft lockup while defragging
Date: Mon, 27 May 2013 21:38:12 +0200
Message-ID: <2462016.qiZEcvOCVp@linux-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

While I was trying to defrag a specified directory I got kernel BUGs and 
warnings about CPUx stucked for twenty-some seconds.

The specified warnings were:
BUG at ctree.c:1144. Invalid opcode: 0000
command: btrfs-endio-wri
Call trace top: btrfs_search_old_slot

The executed command in $HOME/.local:
find -xdev -type f -exec btrfs fi defrag -clzo '{}' \;

After that a soft lockup BUG occurred with systemd-journal with 
btrfs_add_delayed_data_ref being on top of the call trace.

Since no log stayed in the journal, I took some pictures and uploaded them 
here:
- Ctree bug: www.morrohun.hu/temp/btrfs/IMG_1983.JPG
                  www.morrohun.hu/temp/btrfs/IMG_1985.JPG
- Soft lockup with systemd-journal: www.morrohun.hu/temp/btrfs/IMG_1995.JPG
- Same stack trace without lockup and with btrfs-endio-wri: 
www.morrohun.hu/temp/btrfs/IMG_1996.JPG

System: openSUSE 12.3, kernel 3.9.2-3.g97197ff-desktop.

If you need an image, can I take a snapshot just from the specified directory?

Best regards,

Ákos Szőts
