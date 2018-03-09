Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:60498 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932358AbeCIXWv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 18:22:51 -0500
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by alln-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id w29NDMuX020684
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Mar 2018 23:13:23 GMT
From: "Saravanan Shanmugham (sarvi)" <sarvi@cisco.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Change of Ownership of the filesystem content when cloning a volume
Date: Fri, 9 Mar 2018 23:13:21 +0000
Message-ID: <DD5148B6-42C8-4598-A1E5-D652C6CF10E1@cisco.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Netappâ€™s storage system, has the concept of snapshot/clones.
And when I create a clone from a snapshot, I can give/change ownership of entire tree in the volume to a different userid.

Is something like that possible in BTRFS?

We are looking to use CopyOnWrite to snapshot nightly build workspace and clone as developer workspaces to avoid building from scratch for developers,
And move directly for incremental builds.
For this we would like the clone workspace/volume to be instantly owned by the developer cloning the workspace.

Thanks,
Sarvi
-----
Occam's Razor Rules


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
