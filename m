Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965614AbeCGTwJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 14:52:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w27Jpdo5189183
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 19:52:09 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2gjpa082sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 19:52:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w27Jq78i032640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 19:52:07 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w27Jq7aD026348
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 19:52:07 GMT
Date: Wed, 7 Mar 2018 11:49:30 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: Inconsistence between sender and receiver
Message-ID: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In the following steps[1], if <parent> on receiver side has got
changed via 'btrfs property set', then after doing incremental
updates, receiver gets a different snapshot from what sender has sent.

The reason behind it is that there is no change about file 'foo' in
the send stream, such that receiver simply creates a snapshot of
<parent> on its side with nothing to apply from the send stream.

A possible way to avoid this is to check rtransid and ctranid of
<parent> on receiver side, but I'm not very sure whether the current
behavior is made deliberately, does anyone have an idea? 

Thanks,

-liubo

[1]:
$ btrfs sub create /mnt/send/sub
$ touch /mnt/send/sub/foo
$ btrfs sub snap -r /mnt/send/sub /mnt/send/parent

# send parent out
$ btrfs send /mnt/send/parent | btrfs receive /mnt/recv/

# change parent and file under it
$ btrfs property set -t subvol /mnt/recv/parent ro false
$ truncate -s 4096 /mnt/recv/parent/foo

$ btrfs sub snap -r /mnt/send/sub /mnt/send/update
$ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv

$ ls -l /mnt/send/update
total 0
-rw-r--r-- 1 root root 0 Mar  6 11:13 foo

$ ls -l /mnt/recv/update
total 0
-rw-r--r-- 1 root root 4096 Mar  6 11:14 foo

