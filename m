Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36341 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754509AbbDIApY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 20:45:24 -0400
Message-ID: <5525CBA1.5000408@cn.fujitsu.com>
Date: Thu, 9 Apr 2015 08:45:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
References: <201504091039.33442.russell@coker.com.au>
In-Reply-To: <201504091039.33442.russell@coker.com.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

You can use btrfs quota feature to do it.
Like this:

# btrfs quota enable <MNT_POINT>
# btrfs quota rescan -w <MNT_POINT>
# btrfs qgroup show -prce <MNT_POINT>
qgroupid rfer    excl    max_rfer max_excl parent  child
-------- ----    ----    -------- -------- ------  -----
0/5      2248704 12288   0        0        ---     ---
0/256    5509120 3272704 0        0        ---     ---


rfer is all the space the subvolume takes.
excl is the exclusive space the subvolume takes.

You can also refer to 'btrfs-quota'(8) and 'btrfs-qgroup'(8),
Also the following wiki can help:
https://btrfs.wiki.kernel.org/index.php/Quota_support

NOTE: quota is not so stable and has some problem, but should give
you enough info.

Thanks,
Qu

> # zfs list -t snapshot
> NAME                        USED  AVAIL  REFER  MOUNTPOINT
> hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
> hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
> hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
> hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
> hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
> hetz0/be0-mail@2015-03-15   989M      -   386G  -
>
> Is there any way to do something similar to the above ZFS command?  It's handy
> to know which snapshots are taking up the most space, especially when multiple
> subvols are being snapshotted.
>
