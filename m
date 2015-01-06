Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4115 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751176AbbAFGCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jan 2015 01:02:07 -0500
Message-ID: <54AB7A5A.10408@cn.fujitsu.com>
Date: Tue, 6 Jan 2015 14:02:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: RFE: per-subvolume timestamp that is updated on every change
 to a subvolume
References: <20150105172754.GC19126@gardel-login>
In-Reply-To: <20150105172754.GC19126@gardel-login>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: RFE: per-subvolume timestamp that is updated on every change to 
a subvolume
From: Lennart Poettering <lennart@poettering.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月06日 01:27
> Heya!
>
> I am looking for a nice way to query the overall last modification
> timestamp of a subvolume. i.e. the most recent mtime of *any* file or
> directory within a subvolume. Ideally, I think, there was a
> btrfs_timespec field for this in "struct btrfs_root_item", alas there
> isn't afaics. Any chance this can be added?
In fact, btrfs_root_item contains one btrfs_inode_item, which contains 
the a/c/m/otime.
But not sure if it contains the time you need.

I'd better add acmotime output for inode_item in btrfs-debug-tree and 
try myself.

Thanks,
Qu
>
> Or is there another workable way to query this value? Maybe determine
> it from the current generation of a subvolume or so? Is that tracked?
> Ideas?
>
> Lennart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

