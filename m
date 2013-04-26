Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab3DZBVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 21:21:22 -0400
Message-ID: <5179D7B2.2040005@cn.fujitsu.com>
Date: Fri, 26 Apr 2013 09:26:10 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v4 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
References: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net> <1366905892-7880-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366905892-7880-2-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> The function is separated into a preparation part and the three accounting
> steps mentioned in the qgroups documentation. The goal is to make steps two
> and three usable by the rescan functionality. A side effect is that the
> function is restructured into readable subunits.
> 

In fact, you only reuse step1 function, not step2,step3 function..
Otherwise, looks good to me.

Reviewed-by:  Wang Shilong <wangsl-fnst@cn.fujitsu.com>

