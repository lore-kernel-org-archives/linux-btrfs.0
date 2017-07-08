Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.208.21]:51172 "EHLO
        extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbdGHLk0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jul 2017 07:40:26 -0400
Received: from extserver.intern.prnet.org (extserver.prnet.org [192.168.11.1])
        by extserverfr1.prnet.org (8.14.9/8.14.9) with ESMTP id v68BobpF027027
        for <linux-btrfs@vger.kernel.org>; Sat, 8 Jul 2017 13:50:37 +0200
Received: from [IPv6:2001:7e8:cf00:bc00:da50:e6ff:febb:ea28] ([IPv6:2001:7e8:cf00:bc00:da50:e6ff:febb:ea28])
        (authenticated bits=0)
        by extserver.intern.prnet.org (8.14.9/8.14.9) with ESMTP id v68BYi2C014434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Sat, 8 Jul 2017 13:34:45 +0200
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: David Arendt <admin@prnet.org>
Subject: interrupt btrfs filesystem defragment -r /
Message-ID: <8012ff5c-e3a2-557c-69ce-2aa7f300d0ad@prnet.org>
Date: Sat, 8 Jul 2017 13:34:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is it safe to interrupt a btrfs filesystem defrag -r / by using ctrl-c
or should it be avoided ?

Thanks in advance,

David Arendt

