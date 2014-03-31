Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42794 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaCaMbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 08:31:38 -0400
Message-ID: <5339602B.2070207@fb.com>
Date: Mon, 31 Mar 2014 08:31:39 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: don't compress for a small write
References: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/24/2014 05:58 AM, Wang Shilong wrote:
> To compress a small write(<=blocksize) dosen't save us
> disk space at all, skip it can save us some compression time.
>
> This patch can also fix wrong setting nocompression flag for
> inode, say a case when @total_in is 4096, and then we get
> @total_compressed 52,because we do aligment to page cache size
> firstly, and then we get into conclusion @total_in=@total_compressed
> thus we will clear this inode's compression flag.
>
> An exception comes from inserting inline extent failure but we
> still have @total_compressed < @total_in,so we will still reset
> inode's flag, this is ok, because we don't have good compression
> effect.
>

So your check for start > 0 || end + 1 < disk_i_size means we're only 
skipping compression for a small file range that isn't in an inline 
extent.   Could you please update the patch description and comments in 
the code to reflect this?

Thanks!

-chris

