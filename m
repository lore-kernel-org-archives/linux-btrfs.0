Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:46733 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbcAFCOo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 21:14:44 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E9762AC028D
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2016 11:14:39 +0900 (JST)
Subject: Re: [PATCH] Btrfs: fix output of compression message in
 btrfs_parse_options()
To: dsterba@suse.cz
References: <201512160257.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160105141225.GB4227@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <568C7879.3080709@jp.fujitsu.com>
Date: Wed, 6 Jan 2016 11:14:17 +0900
MIME-Version: 1.0
In-Reply-To: <20160105141225.GB4227@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David,

On 2016/01/05 23:12, David Sterba wrote:
> On Wed, Dec 16, 2015 at 11:57:38AM +0900, Tsutomu Itoh wrote:
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 974be09..dcc1f15 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2709,7 +2709,7 @@ int open_ctree(struct super_block *sb,
>>   	 * In the long term, we'll store the compression type in the super
>>   	 * block, and it'll be used for per file compression control.
>>   	 */
>> -	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
>> +	fs_info->compress_type = BTRFS_COMPRESS_NONE;
>
> This would change the default compression type, eg. when the compression
> is turned on via chattr +c . This would break the applications out
> there, the fix has to avoid changing that.

Thanks for pointing that out. I had forgotten chattr +c.
I'll post V2 patch later.

Thanks,
Tsutomu

