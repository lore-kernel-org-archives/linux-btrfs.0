Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65305 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaIYPub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 11:50:31 -0400
Received: by mail-ie0-f169.google.com with SMTP id rp18so11928499iec.14
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 08:50:31 -0700 (PDT)
Received: from [192.168.0.50] (CPE0026f3330aca-CM0026f3330ac6.cpe.net.cable.rogers.com. [99.231.92.7])
        by mx.google.com with ESMTPSA id au4sm7247868igc.3.2014.09.25.08.50.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Sep 2014 08:50:30 -0700 (PDT)
Message-ID: <542439C4.2020900@gmail.com>
Date: Thu, 25 Sep 2014 11:50:28 -0400
From: nick <yocto6@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: XFS Tests
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Fellow Developers,
Today I ran the Xfs test suite on a test drive I have. Further moreI get a few failing tests and will post the results of my run ofxfstests with ./check below. If someone would like my local.conf for debugging purposes please let me known.
Nick
Ran: btrfs/001 btrfs/002 btrfs/004 btrfs/005 btrfs/006 btrfs/008 btrfs/009 btrfs/010 btrfs/011 btrfs/012
Not run: btrfs/003 btrfs/007
Failures: btrfs/006 btrfs/010 btrfs/011
Failed 3 of 10 tests
