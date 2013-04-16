Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:56958 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab3DPJir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:38:47 -0400
Message-ID: <516D1C25.5060103@jan-o-sch.net>
Date: Tue, 16 Apr 2013 11:38:45 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net> <516D17F1.4070208@cn.fujitsu.com>
In-Reply-To: <516D17F1.4070208@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 16, 2013 at 11:20 (+0200), Wang Shilong wrote:
> Hello Jan,
> 
>> The function is separated into a preparation part and the three accounting
>> steps mentioned in the qgroups documentation. The goal is to make steps two
>> and three usable by the rescan functionality. A side effect is that the
>> function is restructured into readable subunits.
> 
> 
> How about renaming the three functions like:
> 
> 1> qgroup_walk_old_roots()
> 2> qgroup_walk_new_root()
> 3> qgroup_rewalk_old_root()
> 
> I'd like this function to be meaningful, but not just step1,2,3.
> Maybe you can think out better function name.

I'd like to keep it like 1, 2, 3, because that matches the documentation in the
qgroup pdf and the code has always been documented in those three steps.

Thanks,
-Jan
