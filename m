Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47247 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752550AbcKRAi1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 19:38:27 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 96097207D9
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 19:38:26 -0500 (EST)
Received: from [192.168.42.7] (82.131.57.134.cable.starman.ee [82.131.57.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 296E87E432
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 19:38:26 -0500 (EST)
To: linux-btrfs@vger.kernel.org
From: Marcus Sundman <sundman@iki.fi>
Subject: root backup-reformat-restore
Message-ID: <7ef59dd2-fbfb-055a-3f5b-b11cc03f4cce@iki.fi>
Date: Fri, 18 Nov 2016 02:38:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The FAQ says that "the best solution for small devices (under about 16 
GB) is to reformat the FS with the --mixed option to mkfs.btrfs".

OK. Does anyone have any good suggestions for doing that with an 
existing / partition (which has special files and whatnot)?

I assume a backup-restore cycle is needed, but with which program(s)?

Thanks!

