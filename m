Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58360 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751890AbaFPBjq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 21:39:46 -0400
Message-ID: <539E49DB.80305@cn.fujitsu.com>
Date: Mon, 16 Jun 2014 09:35:23 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Transaction commit: none (default)
References: <20140614160554.GP6584@merlins.org>
In-Reply-To: <20140614160554.GP6584@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2014 12:05 AM, Marc MERLIN wrote:
> Taking snapshots is now output this in addition of the snapshot
> operation.
>
> Transaction commit: none (default)
>
> 1) Is that expected/normal? It looks kind of spamming/useless to me?
> 2) If it's useful, what's the use I'm not getting?
Addressed a issue that subvolumes reappear after deletetion
if poweroff happen.

http://www.spinics.net/lists/linux-btrfs/msg29547.html
>
> Thanks,
> Marc

