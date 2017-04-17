Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43325 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757095AbdDQBfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 21:35:09 -0400
Received: from _ (localhost [127.0.0.1])
        (Authenticated sender: robbieko@synology.com)
        by synology.com (Postfix) with ESMTPA id 8D349167200D5
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 09:27:27 +0800 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 17 Apr 2017 09:27:27 +0800
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Subject: Extent map generation question
Message-ID: <403da5505e0324c61d117b21fddb5e19@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a question in the function "clone_update_extent_map".

If em->generation is set -1, stands for we can't ignore it in
incremental fsync.

Why em->generation is set -1 when there is a path exists, and the 
generation is always -1.
It can not set to trans-> transid ?

Thanks.
Robbie Ko


