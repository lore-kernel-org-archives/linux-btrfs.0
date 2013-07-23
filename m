Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3GWIoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 04:44:20 -0400
Message-ID: <51EE4227.7070907@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 16:43:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] Btrfs: add missing mounting options in btrfs_show_options()
References: <51EE130A.7020101@cn.fujitsu.com> <51EE3427.4010901@giantdisaster.de>
In-Reply-To: <51EE3427.4010901@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/2013 03:43 PM, Stefan Behrens wrote:
> On Tue, 23 Jul 2013 13:22:18 +0800, Wang Shilong wrote:
>> +    if (btrfs_test_opt(root, RECOVERY))
>> +        seq_puts(seq, ",auto_recovery");
> "recovery" without the "auto_"
Thanks, i will update the patch ^_^

Wang,
>
>

