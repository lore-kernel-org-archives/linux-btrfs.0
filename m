Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab3LZFls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 00:41:48 -0500
Message-ID: <52BBC1CE.9040502@cn.fujitsu.com>
Date: Thu, 26 Dec 2013 13:42:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Barrier remount failure
References: <CAMVG2ssVrki1M-90yh7uBaqsi4tfJxDgwffaNYYKLizZ+Z7zGA@mail.gmail.com>
In-Reply-To: <CAMVG2ssVrki1M-90yh7uBaqsi4tfJxDgwffaNYYKLizZ+Z7zGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 26 Dec 2013 13:31:08 +0800, Daniel J Blueman wrote:
> On 3.13-rc5, it's possible to remount a mounted BTRFS filesystem with
> 'nobarrier', but not possible to remount with 'barrier'.
>
> Is this expected?
>
> Many thanks,
>    Daniel
Not quite sure, but from the source of btrfs_parse_options,
barrier is not in the options that btrfs supports.

Other fs like ext4 supports it, so I think btrfs should also support it.
I'll try to add the "barrier" option soon.

For now, you can umount and mount again without any barrier related 
options, and btrfs will enable barrier by default.

Qu
