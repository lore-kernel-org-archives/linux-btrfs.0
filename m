Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3LQL7C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 06:59:02 -0500
Message-ID: <52B03C60.6060007@cn.fujitsu.com>
Date: Tue, 17 Dec 2013 19:58:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Check read-only status of roots during send
References: <cover.1387211245.git.dsterba@suse.cz> <c80eb84e6c8ab788de0f73e332755e27d518f7fd.1387211246.git.dsterba@suse.cz>
In-Reply-To: <c80eb84e6c8ab788de0f73e332755e27d518f7fd.1387211246.git.dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David,

Nice work, Before this patch for btrfs send.
we have to join a transaction to avoid commit root changed.

I send a plus patch that remove transaction protection from btrfs send.
and  a little comment below.

[...]
On 12/17/2013 12:34 AM, David Sterba wrote:
> All the subvolues that are involved in send must be read-only during the
>   s via SUBVOL_SETFLAGS
> +	 */
> +	int send_in_progress;

Why not use u32 here?

Thanks,
Wang

