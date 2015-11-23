Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895AbbKWBA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 20:00:59 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Laurent Bonnaud <L.Bonnaud@laposte.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net>
CC: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56526543.4090301@cn.fujitsu.com>
Date: Mon, 23 Nov 2015 09:00:51 +0800
MIME-Version: 1.0
In-Reply-To: <56519644.8060105@laposte.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Laurent Bonnaud wrote on 2015/11/22 11:17 +0100:
> On 22/11/2015 03:04, Qu Wenruo wrote:
>
>> If any of you can recompile btrfs-progs and use gdb to debug it,
>> would anyone please to investigate where did the wrong_chunk_type is
>> set?
>
> In the mean time my btrfs filesystem degraded
>
> Nov 20 18:10:53 irancy kernel: BTRFS: device label sauvegarde-IUT2 devid 1 transid 9056 /dev/sdb1
> Nov 20 18:10:53 irancy kernel: BTRFS info (device sdb1): disk space caching is enabled
> Nov 20 18:10:56 irancy kernel: BTRFS: checking UUID tree
> Nov 20 18:12:06 irancy kernel: BTRFS info (device sdb1): disk space caching is enabled
> Nov 20 18:12:49 irancy kernel: BTRFS warning (device sdb1): block group 314635714560 has wrong amount of free space
> Nov 20 18:12:49 irancy kernel: BTRFS warning (device sdb1): failed to load free space cache for block group 314635714560, rebuild it now
> Nov 20 18:12:51 irancy kernel: BTRFS: Transaction aborted (error -17)
> Nov 20 18:12:51 irancy kernel: BTRFS: error (device sdb1) in btrfs_run_delayed_refs:2781: errno=-17 Object already exists

Not pretty sure about the free space error for blockgroup,
but the btrfs_run_delayed_refs problem seems to be a regression from 
4.2-rc1.
And should be fixed in 4.3-rc1, or just revert to 4.1, where my qgroup 
rework(with a delayed_ref regression) is not introduced.

> Nov 20 18:12:51 irancy kernel: BTRFS info (device sdb1): forced readonly
> Nov 20 18:12:51 irancy kernel: BTRFS warning (device sdb1): Skipping commit of aborted transaction.
> Nov 20 18:12:51 irancy kernel: BTRFS: error (device sdb1) in cleanup_transaction:1710: errno=-17 Object already exists
> Nov 20 19:25:37 irancy kernel: BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> Nov 20 19:25:37 irancy kernel: BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> Nov 20 19:25:37 irancy kernel: BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> Nov 20 19:25:37 irancy kernel: BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> [...]
>
> Are you interested in the output of btrfs-image ?  No idea of the size (I am running it currently) but here some info about its size:
>
> # btrfs fi df /mnt/sauvegarde/
> Data, single: total=1.81TiB, used=1.79TiB
> System, DUP: total=32.00MiB, used=240.00KiB
> Metadata, DUP: total=7.00GiB, used=5.38GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
Considering the size, I'd like not to touch the dump, metadata is over 
5G, and I think it's not related to on-disk data, but runtime problem 
like I mentioned above.

Thanks,
Qu
