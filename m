Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbGXNjg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 09:39:36 -0400
Date: Fri, 24 Jul 2015 15:39:27 +0200
From: David Sterba <dsterba@suse.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs-progs: Fix wrong address accessing by
 subthread in btrfs-convert
Message-ID: <20150724133927.GZ6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 09:16:25PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>

Good catch!

> We can reproduce this bug by a simple script:
>   DEV=/dev/vdh
>   for ((i = 0; i < 100; i++)); do
>       echo "loop $i"
>       mkfs.ext4 "$DEV" &>/dev/null || { echo mkfs fail; break; }
>       btrfs-convert "$DEV" || break
>   done

Can you please turn it into a testing script? Just put it into the misc
tests and add the usual preamble and paths. I'll apply this series, so
separate patch please, thanks.
