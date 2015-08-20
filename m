Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:56457 "EHLO
	mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbbHTRRn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 13:17:43 -0400
Received: from hydrangea (218-45-17-17.flets.kamome.or.jp [218.45.17.17])
	by mail.reasonset.net (Postfix) with ESMTPSA id 6D51825108E6
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 02:11:47 +0900 (JST)
Date: Fri, 21 Aug 2015 02:11:46 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive freezes a system
Message-Id: <20150821021146.eb0d8b756fe7f3600685ee53@reasonset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I want to "soft" mirroring between two remote btrfs volumes.
I tried to use btrfs send/receive instead of rsync
(because rsync to btrfs volume freeze btrfs
http://www.spinics.net/lists/linux-btrfs/msg44695.html)

But it failed everytime.

1st ) Pipe with SSH, to fresh filesystem. sender was flozen after transfared 2.79TiB.
2nd ) Delete snapshots and try again. sender was flozen after transfared 1.34TiB.
3rd ) Delete snapshots and try again. sender was flozen after transfared 22.23GiB.
4th ) Pipe with SSH, to fresh filesystem. sender was flozen after transfared 2.79TiB.
5th ) Redirect with SSH to fresh filesystem. btrfs send process stalled after transfared 1803363706900 Bytes.
6th ) Pipe with nc, to fresh filesystem. btrfs send process stalled after transfared 179.54GiB

When froze sender system.
I Couldn't see live signal in sender system.
ssh process was dead but btrfs receive process was alive.

When stalled btrfs send/receive processes.
I could stop process in the receiver and sender.
But receiver coudn't shutdown because btrfs filesystem was busy.

What is wrong?

Thanks in Advance.


[Environment]
(Sender)
Manjaro 0.8.13
Linux 4.1.5-1-MANJARO
AMD A10-K7700 Processor
16GB RAM
(Receiver)
CentOS 7
Linux 3.10.0-229.11.1.el7.x86_64
Turion II NEO N54L Processor
4GB RAM

Sending snapshot size: 3.8TiB.
Connection: Link local GbE.
Sending snapshot is readonly.


******************************
* +++ ENABLE YOUR HEART +++
******************************
*           MASAKI Yuhsuke.
* yek@reasonset.net
* Website: http://reasonset.net/
* GitHub : https://github.com/reasonset/
* Twitter: @reasonset
******************************
