Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37525 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbdAZJSz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 04:18:55 -0500
Received: by mail-wm0-f42.google.com with SMTP id c206so73258912wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jan 2017 01:18:49 -0800 (PST)
Received: from ?IPv6:2a01:5c0:13:d671:2d0c:9f8d:9c0:9c86? ([2a01:5c0:13:d671:2d0c:9f8d:9c0:9c86])
        by smtp.googlemail.com with ESMTPSA id s26sm1516620wra.26.2017.01.26.01.18.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Jan 2017 01:18:41 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: btrfs recovery
Message-ID: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
Date: Thu, 26 Jan 2017 10:18:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I have just encountered on mount of one of my filesystems (after a clean reboot...): 
[  495.303313] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=243
[  495.315642] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=243
[  495.315694] BTRFS error (device sdb1): failed to read block groups: -5
[  495.327865] BTRFS error (device sdb1): open_ctree failed

The system is using a 4.9.0 kernel, and I have btrfs-progs 4.9 installed. 

Since the last backup is a few weeks old (but the data is not so crucial), I'd like to attempt to recover at least some of the files. 

btrfs check tells me:
# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: cfd16c65-7f3b-4f5e-9029-971f2433d7ab
checking extents
bad block 35028992
ERROR: errors found in extent allocation tree or chunk allocation

IIRC, the FS has DUP metadata (but single DATA). It's on a classic spinning disk. 
I use: "space_cache,noatime,compress=lzo,commit=120" as mount options. 

What is the best way to go? 

Should I:
- reinit extent tree
- or collect debug info
- or is there a better way to go?

Cheers and thanks for any suggestions, 
	Oliver

PS: Please put my mail in CC, I'm not subscribed to the list. Thanks! 
