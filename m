Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:47557 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGIJPo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 05:15:44 -0400
Message-ID: <53BD0839.7030907@xunil.at>
Date: Wed, 09 Jul 2014 11:15:37 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mount in gentoo linux
References: <53BC4172.8080300@xunil.at> <pan.2014.07.08.20.19.04@googlemail.com> <53BC5A1A.7020403@xunil.at> <53BCA17D.9060301@cn.fujitsu.com>
In-Reply-To: <53BCA17D.9060301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 09.07.2014 03:57, schrieb Qu Wenruo:

>> The "[/rootfs]" is something in the right direction ...
> The bug is that, if you don't use 'subvol=' mount option but use default
> subvolume or 'subvolid=' mount option,
> findmnt will not give the output.

Yes, that sounds true as I switched to mostly using 'subvolid=' over
times. I also use that in my fstab.

> Since 'subvol=' mount option differs from default subvolume mount or
> 'subvolid=' mount option in calling behavior,
> 'subvol=' uses mount_subtree() vfs call, which records subtree mount info.
> On the other hand, default subvolume mount or 'subvolid=' mount does not
> go through the vfs subtree mount
> but use btrfs's implement, which does not report vfs submount.

OK, good explanation ;-)

> I'll try to investigate further and find whether we can fix it to show
> more info.

Thanks a lot, I think this would be a more expectable behavior in the end.

Stefan
