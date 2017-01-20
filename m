Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19042 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751118AbdATCuY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 21:50:24 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 80DEB47B0CB4
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jan 2017 10:50:12 +0800 (CST)
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [RFC] btrfs-progs: btrfs-corrupt-block refactor
Message-ID: <2987570c-aeb2-e497-ee9f-c32b8a0fb3ff@cn.fujitsu.com>
Date: Fri, 20 Jan 2017 10:50:10 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the RFC proposal for refactor btrfs-corrupt-block.

Just as Lakshmipathi and xfstests guys commented in btrfs ML, we need 
btrfs-corrupt-block to either craft a test case, or for later RAID56 
corruption test case.

However the current situation of btrfs-corrupt-block has several 
problems, and those problems prevents us from using it:

1) Bad arranged options
    Quite a lot of combination makes no sense.
    And quite a lot of function covers each other.

    This is quite frustrating when someone want to use it.

2) No documentation

3) No longer default installed/compiled
    This is OK if such tool is only used to corrupt things.

    But if the long term objective is to provide a tool to modify the fs
    offline at will, that's not a good idea.


So here I want to refactor the current btrfs-corrupt-block to archive 
the following objective:

1) Logical layer divided parameters  <<MAIN PART>>
    The current idea is like:

    btrfs-corrupt-block <dest> <options>
    <dest> is one of
      "item" "data" "leaf" "node" (with more to come)

    "item"/"leaf"/"node" common options are:
      "--nocow":
         Don't do CoW, but overwrite (default)
      "--cow":
         Do normal tree block CoW
      "--pattern DATA"
         The pattern to fill, default to 0xcd


    "item" options are:
      "--root NUMBER|ROOTID":
         Mandatory
      "--key (OBJID,TYPE,OFFSET)":
         Mandatory
      "--field FIELD"
         Optional, default to corrupt all fields of the item
      "--delete"
         Optional, if specified, the item will be deleted.
         Conflicts with "--field"


    "leaf" options are:
      "--bytenr BYTENR" or "--key" with "--root"
         Mandatory to locate the leaf
      "--field FIELD"
         Optional, default to corrupt all fields of the leaf header
         With --key, can also be used to corrupt certain item field
      NOTE: No delete is provided. Please use "node" "--delete" to
            delete a leaf.
            Or use "--filed ALL" with "--pattern 0x00" to wipe the
            leaf header.

    "node" options are:
      "--bytenr BYTENR" or "--key" "--root" and "--level"
         Mandatory to locate the node
      "--field FIELD"
         Optional, default to corrupt all fields of the node header
         With --key, can also be used to corrupt certain nodeptr filed
      "--delete"
         Optional, Only works with "--key" "--root" "--level".
         Delete the nodeptr.

    "data" options are:
      "--bytenr BYTENR"
         Mandatory, logical address
      "--length LENGTH"
         Optional, default to sectorsize of the fs
      "--mirror"
         Optional, default to all mirror

     May add "raid56" destination for raid56 tests later.

2) Better documentation
    Both asciidoc doc and better help string

3) Better error string
    At least the same level we do in other btrfs commands

Any advice and idea are welcomed.

Thanks,
Qu


