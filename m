Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:39106 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdJSIej (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 04:34:39 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id F14B2AC0109
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 17:34:32 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: change mans to describe the third copy of
 superblock
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <87y3o7zikq.wl-satoru.takeuchi@gmail.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <1451864a-8a7a-9cdc-d507-fb4f10059dea@jp.fujitsu.com>
Date: Thu, 19 Oct 2017 17:34:22 +0900
MIME-Version: 1.0
In-Reply-To: <87y3o7zikq.wl-satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/10/19 16:45, Satoru Takeuchi wrote:
> Some tools can select which superblock these commands use by "-s <superblock>"
> option. Although this option says the valid values are 0-2, we can set 3
> if filesystem is very large.
> 

Hello, 
Wiki says there are 4 superblocks. However in the implementation BTRFS_SUPER_MIROR_MAX
is 3 and 0 indicates the block at 64K (disk-io.h of btrfs-progs), therefore I think
there is no 4th superblock actually.

Regards,
Tomohiro

