Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44676 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbAPHdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 02:33:15 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id D8B013EE1C0
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Jan 2015 16:33:13 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DCFBAAC033A
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Jan 2015 16:33:12 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 8C7A9E08001
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Jan 2015 16:33:12 +0900 (JST)
Message-ID: <54B8BEAF.50700@jp.fujitsu.com>
Date: Fri, 16 Jan 2015 16:33:03 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug in 3.19-rc4
References: <672b579b39da1cc6fa5f91ba4b964731@admin.virtall.com>
In-Reply-To: <672b579b39da1cc6fa5f91ba4b964731@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2015/01/16 10:05, Tomasz Chmielewski wrote:
>> I just started some btrfs stress testing on latest linux kernel 3.19-rc4:
>> A few hours later, filesystem stopped working - the kernel bug report
>> can be found below.
>
> Hi,
>
> your "kernel BUG at fs/btrfs/inode.c:3142!" from 3.19-rc4 corresponds to http://marc.info/?l=linux-btrfs&m=141903172106342&w=2 - it was "kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123!" in 3.18.1, and is exactly the same code in both cases:
>
>
>          /* grab metadata reservation from transaction handle */
>          if (reserve) {
>                  ret = btrfs_orphan_reserve_metadata(trans, inode);
>                  BUG_ON(ret); /* -ENOSPC in reservation; Logic error? JDM */
>          }

Year, it's the same.

BTW, I've tried to reproduce this problem by using the way
you told me. However, it hasn't reproduced yet.

Thanks,
Satoru

