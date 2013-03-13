Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:38174 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754138Ab3CMFkX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 01:40:23 -0400
Message-ID: <51400F2F.5060109@parallels.com>
Date: Wed, 13 Mar 2013 14:31:27 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: Alex <alex@bpmit.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: File space cache
References: <loom.20130312T171252-0@post.gmane.org>
In-Reply-To: <loom.20130312T171252-0@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Alex,

On 03/13/2013 01:17 AM, Alex wrote:
> Hi All,
>
> It seems my btrfs file space cache is corrupt; I had to run clear the log
> through a kernel problem.
>
> I've seen messages that the cache is rebuilt automatically, but this doesn't
> seem to be true as the messages that the free space is what is expected keep
> coming.
>
> I'm running kernel 3.8.2 (Siduction) on Debian testing.


I believe you may try clear_cache mount option
https://btrfs.wiki.kernel.org/index.php/Mount_options


>
> As a subsidiary question, please, should the <pass> value in fstab be zero or
> non-zero?


It should be zero. But since fsck.btrfs is non-existent, it does not 
really matter I guess.


~dima


> Kind regards.
>
> Al.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
