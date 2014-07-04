Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47091 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDCNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:13:55 -0400
Received: by mail-ie0-f179.google.com with SMTP id lx4so131394iec.38
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 19:13:54 -0700 (PDT)
Received: from [192.168.1.2] ([216.26.106.6])
        by mx.google.com with ESMTPSA id b10sm57965615igf.20.2014.07.03.19.13.53
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 03 Jul 2014 19:13:54 -0700 (PDT)
Message-ID: <53B60DE1.9070905@gmail.com>
Date: Thu, 03 Jul 2014 21:13:53 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Quota Ignored On write
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

basing of the latest for-linus branch i found i can write way more than
the quota

btrfs quota enable
btrfs subvolume create test
btrfs qgruop limit 1G test
dd if=/dev/zero of=test/file bs=1024 count=1500000
output:
1500000+0 records in
1500000+0 records out
1536000000 bytes (1.5 GB) copied, 5.91909 s, 259 MB/s

thats a full half gig over the quota limit. I noticed some changes to
the quota
accounting in the logs, what changed that could cause this?

-Kevin Brandstatter
