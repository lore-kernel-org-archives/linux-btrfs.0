Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbaC0DId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 23:08:33 -0400
Message-ID: <533395A4.4020601@cn.fujitsu.com>
Date: Thu, 27 Mar 2014 11:06:12 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: don't compress for a small write
References: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140326181053.GU29256@twin.jikos.cz>
In-Reply-To: <20140326181053.GU29256@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not really, you just miss inline part, say we compress a page
to 50B, but this inode's data can not be inlined(see inline check),
we still have to allocate 'blocksize'(min allocating unit) disk space
and then write data and zero filled datas into disk.

This patch only skips data can not be inlined, so i think this make senses.

Thanks,
Wang

On 03/27/2014 02:10 AM, David Sterba wrote:
> On Mon, Mar 24, 2014 at 05:58:10PM +0800, Wang Shilong wrote:
>> To compress a small write(<=blocksize) dosen't save us
>> disk space at all, skip it can save us some compression time.
> The compressibility depends on the data, a block full of zeros can
> compress pretty well, so your patch is too limiting IMO.
>
>> This patch can also fix wrong setting nocompression flag for
>> inode, say a case when @total_in is 4096, and then we get
>> @total_compressed 52,because we do aligment to page cache size
>> firstly, and then we get into conclusion @total_in=@total_compressed
>> thus we will clear this inode's compression flag.
> This is a bug but can be fixed without disabling compression of small
> blocks.
>
> I have a similar patch as part of the large compression update, the
> logic that decides if the small extent should be compressed or not
> depends on the compression algo and some typical data samples. for zlib
> it's around ~100 B and lzo at ~200 B. That's a boundary where compressed
> size == uncompressed, so there's no benefit, only additional overhead.
>

