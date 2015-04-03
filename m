Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47500 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923AbbDCAh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 20:37:58 -0400
Message-ID: <551DE0E4.6080502@cn.fujitsu.com>
Date: Fri, 3 Apr 2015 08:37:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: Doc: Add warning and note on btrfs-convert.
References: <1427336364-18161-1-git-send-email-quwenruo@cn.fujitsu.com> <20150402151931.GK6821@twin.jikos.cz>
In-Reply-To: <20150402151931.GK6821@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH v2] btrfs-progs: Doc: Add warning and note on 
btrfs-convert.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月02日 23:19

> On Thu, Mar 26, 2015 at 10:19:24AM +0800, Qu Wenruo wrote:
>> +WARNING: To ensure *btrfs-convert* be able to rollback btrfs, one should never
>> +execute *btrfs filesystem defragment* or *btrfs balance* command on the
>> +converted btrfs.
>
> So it looks like a fundamental problem, not lack of implementation. The
> original filesystem has some correspondence between physical blocks (1:1
> match in ext) and btrfs blocks (where the mapping is not 1:1, though
> from the beginning physical matches logical).
>
> Once we balance data, the chunks get moved and the original phyisical
> offset is lost. We'd have to remember that somewhere and restore upon
> rollback.
>
> I don't see now why defrag is harmful to rollback. The defragmented data
> are written to the "ext free space", ie. where all new modifications get
> written. The old data are pinned by the ext2_saved subvolume and can be
> restored. Or not?
>
Oh, I forgot ext*_image is readonly, so defrag should be OK.

I'll remove defrag from warning.

BTW, although we use 1:1 physical bytenr and if the extent is moved, we 
lost its physical bytenr, but we still have its offset in ext*_image, 
and its logical file offset is the same as its original physical bytenr.

So, why not use file offset as physical bytenr to do rollback?
It should make btrfs-convert to rollback even after balance.

Thanks,
Qu

