Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47475 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760505AbcLVCY5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 21:24:57 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: [bug or by design ?] btrfs defrag compression does not persist
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Message-ID: <16053303-2857-9729-a94f-d697004f019d@oracle.com>
Date: Thu, 22 Dec 2016 10:28:28 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


A quick design specific question.

The following command converts file-data-extents to the specified
encoder (lzo).

   $ btrfs filesystem defrag -v -r -f -clzo dir/

However the lzo property does not persist through the file modify.
As the above operation does not update the btrfs.compression property.

Question:
  I wonder if this should be a bug or if its by design ?
  What could be the main use case to _associate compression
  at the time of defrag_ ?
  The no-conflict fix will be to add another option to make
  it persistent.

Thanks, Anand
