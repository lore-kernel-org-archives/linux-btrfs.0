Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbbIYIbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 04:31:53 -0400
Message-ID: <56050619.7060401@oracle.com>
Date: Fri, 25 Sep 2015 16:30:17 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: Do per-chunk degraded check for remount
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com> <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com> <5604EF8B.5060503@oracle.com> <560500F8.9070105@cn.fujitsu.com>
In-Reply-To: <560500F8.9070105@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu,

Strictly speaking IMO it should be reported to the user on the cli 
terminal, and no logging in required. since its not that easy to get 
that at this point, I am ok with logging it as error. Since we are 
failing the task(mount), error is better.

I have made that change this on top of the patch

   [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()

and sent them both.

Thanks, Anand


> Thanks for pointing this out.
>
> I was quite unsure about using btrfs_info/warn/error.
>
> In this case, I just wan't to output a dmesg info to let user know
> exactly what caused the mount failed.
> Original code output nothing but "failed to open chunk tree", which is
> quite confusing for end user.
>
> I was planning to use btrfs_info, but at least this is really an error
> message, but only to info user the real cause.
>
> Maybe btrfs_warn will be a better choice?
>
> Thanks,
> Qu


