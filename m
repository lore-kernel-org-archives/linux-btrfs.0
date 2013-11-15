Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55285 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3KOK3m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 05:29:42 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi5so770285wib.13
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 02:29:41 -0800 (PST)
Received: from venice.bhome (ppp-198-95.24-151.libero.it. [151.24.95.198])
        by mx.google.com with ESMTPSA id eu11sm3635932wid.10.2013.11.15.02.29.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2013 02:29:40 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] BTRFS-PROG: prefix with ERROR the mkfs error messages
Date: Fri, 15 Nov 2013 11:29:35 +0100
Message-Id: <1384511376-14740-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Prefix with "ERROR:" the error messages of mkfs

Add the ERROR prefix to the error messages of mkfs, to align it
to the btrfs main utility style.

The patch also increase the buffer size of test_dev_for_mkfs() and 
test_num_disk_vs_raid() for the error message from 100 to 150
because the former become too small.

