Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbbG0N1E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:27:04 -0400
Date: Mon, 27 Jul 2015 15:26:53 +0200
From: David Sterba <dsterba@suse.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] btrfs-progs: Fix wrong address accessing by
 subthread in btrfs-convert
Message-ID: <20150727132653.GC6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <cover.1437999624.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1437999624.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 08:24:25PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> Zhao Lei (7):
>   btrfs-progs: Fix wrong address accessing by subthread in btrfs-convert
>   btrfs-progs: Move close timer handle code to line after sub process
>     exit
>   btrfs-progs: Remove cleanup-timer code for btrfs-convert
>   btrfs-progs: resst info->periodic.timer_fd's value after free
>   btrfs-progs: Set info->periodic.timer_fd to 0 in init-fail
>   btrfs-progs: Move code to create loop device to common
>   btrfs-progs: Introduce a misc test for thread conflict in
>     btrfs-convert

Replaced the existing and added the new ones, thanks!
