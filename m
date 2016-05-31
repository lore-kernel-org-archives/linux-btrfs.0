Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:64487 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcEaXnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 19:43:37 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E92FCAC00F8
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 08:43:31 +0900 (JST)
Subject: Re: Very quick embarrassing q: /var/lib permissions.
To: al <6401e46d@opayq.com>, linux-btrfs@vger.kernel.org
References: <loom.20160531T234453-643@post.gmane.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <d0551873-1579-66b1-08c5-d002e721612f@jp.fujitsu.com>
Date: Wed, 1 Jun 2016 08:43:03 +0900
MIME-Version: 1.0
In-Reply-To: <loom.20160531T234453-643@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/01 6:53, al wrote:
> Please can someone run:
>
> # ls -l /var/lib/ | grep btrfs
>
> for me (and post to directly or via list as they think fit).

================================
$ ls -l /var/lib | grep btrfs
drwxr-xr-x  1 root          root          196 May 18 10:34 btrfs
================================

This directory will be created when you run "btrfs scrub start"
for the first time.

Thanks,
Satoru

>
> Thank you.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
