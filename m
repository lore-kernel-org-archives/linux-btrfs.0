Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab3DOGEk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:04:40 -0400
Message-ID: <516B9968.90701@cn.fujitsu.com>
Date: Mon, 15 Apr 2013 14:08:40 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net> <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net> <20130410164741.GS18193@twin.jikos.cz> <516B93C3.4080306@jan-o-sch.net> <516B9701.9040409@jan-o-sch.net>
In-Reply-To: <516B9701.9040409@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> On Mon, April 15, 2013 at 07:44 (+0200), Jan Schmidt wrote:
>> Thanks, v2 to come.
> 
> Uh, but not immediately. I didn't get tracking of "exclusive" right. That will
> need some time to fix and test.


'exclusive' adds the complexity of btrfs qgroup.
So if you send V2. I'd like you add more lines in changelog.

Besides, i have a question in my mind.(I have not seen you code)..
When qgroup rescan  will happen?

1> when quota is enabled
2> if a new qgroup relations is created, rescan should happen?
2> user call qgroup rescan..


Thanks,
Wang

> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



