Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64146 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaCaMxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 08:53:08 -0400
Received: by mail-qg0-f47.google.com with SMTP id 63so7295336qgz.34
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 05:53:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5339602B.2070207@fb.com>
References: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<5339602B.2070207@fb.com>
Date: Mon, 31 Mar 2014 20:53:05 +0800
Message-ID: <CAP9B-Qk+t3Sm80PvB8h0sa1zg0H1j=9ghdiQss6jFk2sRgJ15g@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: don't compress for a small write
From: Shilong Wang <wangshilong1991@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-03-31 20:31 GMT+08:00 Chris Mason <clm@fb.com>:
>
>
> On 03/24/2014 05:58 AM, Wang Shilong wrote:
>>
>> To compress a small write(<=blocksize) dosen't save us
>> disk space at all, skip it can save us some compression time.
>>
>> This patch can also fix wrong setting nocompression flag for
>> inode, say a case when @total_in is 4096, and then we get
>> @total_compressed 52,because we do aligment to page cache size
>> firstly, and then we get into conclusion @total_in=@total_compressed
>> thus we will clear this inode's compression flag.
>>
>> An exception comes from inserting inline extent failure but we
>> still have @total_compressed < @total_in,so we will still reset
>> inode's flag, this is ok, because we don't have good compression
>> effect.
>>
>
> So your check for start > 0 || end + 1 < disk_i_size means we're only
> skipping compression for a small file range that isn't in an inline extent.
> Could you please update the patch description and comments in the code to
> reflect this?

No problem, i will update this patch.~_~

>
> Thanks!
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
