Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752908AbdJaTWF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 15:22:05 -0400
From: Nick Terrell <terrelln@fb.com>
To: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix default compression value when set by SETFLAGS
 ioctl
Date: Tue, 31 Oct 2017 19:21:59 +0000
Message-ID: <6D6419B4-89D2-4581-8776-726007201343@fb.com>
References: <20171031164551.6447-1-dsterba@suse.com>
In-Reply-To: <20171031164551.6447-1-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/17, 9:48 AM, "David Sterba" <dsterba@suse.com> wrote:
> The current default for the compression file flag is 'zlib', the zstd
> patch silently changed that to zstd. Though the choice of zlib might not
> be the best one, we should keep the backward compatibility.

Sorry about that, I didn't intentionally change it. I checked over my patch,
and the only other place where an "else" was changed is the other place in
ioctl.c, which looks okay to me.

I'm trying to expose the buggy case in 4.14-rc7. However, since
fs_info->compress_type defaults to ZLIB when -compress is not passed, and
when -compress=no is passed, fs_info->compress_type is not modified, I
don't know how to get fs_info->compress_type to be BTRFS_COMPRESS_NONE.
Is there a way that fs_info->compress_type can be BTRFS_COMPRESS_NONE?

I modified -compress=no to set fs_info->compress_type=BTRFS_COMPRESS_NONE
and the ioctl() call set the compression type to zstd before your patch,
and zlib after, as expected.

Tested-by: Nick Terrell <terrelln@fb.com>

> The incompat bit for zstd is not set, so this could lead to a filesystem
> with a zstd compression in the extents but no flag for the filesystem.
>
> Fixes: 5c1aab1dd5445ed8bd ("btrfs: Add zstd support")
> CC: Nick Terrell <terrelln@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
