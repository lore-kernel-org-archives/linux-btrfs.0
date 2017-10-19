Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58518 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdJSJF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 05:05:29 -0400
Subject: Re: [PATCH] btrfs-progs: change mans to describe the third copy of
 superblock
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <87y3o7zikq.wl-satoru.takeuchi@gmail.com>
 <1451864a-8a7a-9cdc-d507-fb4f10059dea@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <af16ecf9-2cc5-16bb-c5a8-977bcbdbc124@gmx.com>
Date: Thu, 19 Oct 2017 17:05:18 +0800
MIME-Version: 1.0
In-Reply-To: <1451864a-8a7a-9cdc-d507-fb4f10059dea@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月19日 16:34, Misono, Tomohiro wrote:
> On 2017/10/19 16:45, Satoru Takeuchi wrote:
>> Some tools can select which superblock these commands use by "-s <superblock>"
>> option. Although this option says the valid values are 0-2, we can set 3
>> if filesystem is very large.
>>
> 
> Hello, 
> Wiki says there are 4 superblocks. However in the implementation BTRFS_SUPER_MIROR_MAX
> is 3 and 0 indicates the block at 64K (disk-io.h of btrfs-progs), therefore I think
> there is no 4th superblock actually.

Kernel implementation also shows that it will only update up to 3
superblocks:

---
	if (max_mirrors == 0)
		max_mirrors = BTRFS_SUPER_MIRROR_MAX;

	for (i = 0; i < max_mirrors; i++) {
		bytenr = btrfs_sb_offset(i);
		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
		    device->commit_total_bytes)
			break;
---

And BTRFS_SUPER_MIRROR_MAX is 3:
---
#define BTRFS_SUPER_MIRROR_MAX	 3
---

So even you can set any value and btrfs_sb_offset() can calculate the
super block offset, you will just read out some garbage.

Thanks,
Qu
> 
> Regards,
> Tomohiro
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
