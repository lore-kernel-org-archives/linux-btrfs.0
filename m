Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:19615 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbcAYCem (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 21:34:42 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 18B88AC02B6
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 11:24:27 +0900 (JST)
Subject: Re: [PATCH] Btrfs: fix error number in send.c
To: dsterba@suse.cz
References: <201601220013.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160122140043.GS4227@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <56A58737.906@jp.fujitsu.com>
Date: Mon, 25 Jan 2016 11:23:51 +0900
MIME-Version: 1.0
In-Reply-To: <20160122140043.GS4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David,

On 2016/01/22 23:00, David Sterba wrote:
> On Fri, Jan 22, 2016 at 09:13:25AM +0900, Tsutomu Itoh wrote:
>> ENOTSUPP should not be returned to the user program.
>>   (cf. include/linux/errno.h)
>> Therefore, EOPNOTSUPP is used instead of ENOTSUPP.
>
> I'm not sure that EOPNOTSUPP is the right error code here. I'd rather
> make it EINVAL, the bug we're talking about is a new type of inode
> outside of the S_IFMT bits. "not supported" would mean we don't support
> it but we could in theory.

Thanks for review.

In the meaning that btrfs-send is not supporting a new type of inode now,
EOPNOTSUPP is acceptable, I think.

Thanks,
Tsutomu

