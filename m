Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52076 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaLBHOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 02:14:35 -0500
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by fgwmail7.fujitsu.co.jp (Postfix) with ESMTP id 39DA81792418
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 16:14:07 +0900 (JST)
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9D9B53EE0BD
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 16:14:05 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9DD1DAC0418
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 16:14:04 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4E03CE08009
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 16:14:04 +0900 (JST)
Message-ID: <547D663A.3020201@jp.fujitsu.com>
Date: Tue, 2 Dec 2014 16:11:54 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
In-Reply-To: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(2014/11/30 12:33), Shriramana Sharma wrote:
> IIUC with BtrFS while it is possible to easily undelete a file or
> ordinary directory if a snapshot of the containing subvol exists, it
> seems that it's not elementary to undelete a subvol itself, because
> all subvols are under the root-level subvol (id 0 or 5, see my other
> q) but even snapshotting the root subvol will not snapshot any subvols
> under it.
>
> So is there any way to undo a subvol delete?
>
> [If no, then ordinary users should probably prefer regular directories
> to subvols.]
>

One solution is using snapper instead of using btrfs directly.
Snapper can automatically take a snapshot just before
taking/deleting snapshots. So, if you delete a snapshot
by mistake, it's still alive.

For more information, please refer to the following URLs.

https://en.opensuse.org/Portal:Snapper
http://events.linuxfoundation.org/sites/events/files/slides/LinuxCon_Europe_2014_Full_system_rollback_btrfs_snapper_0.pdf

Thanks,
Satoru

