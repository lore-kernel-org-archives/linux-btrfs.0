Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35051 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbHSQUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 12:20:49 -0400
Received: by lahi9 with SMTP id i9so6285981lah.2
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 09:20:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D4A331.7000202@gmail.com>
References: <55D4A331.7000202@gmail.com>
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Wed, 19 Aug 2015 18:20:28 +0200
Message-ID: <CABL_Pd-18cQHiK0y7zidySkVQrMSc82CK9ecspWqiYz24s5QFA@mail.gmail.com>
Subject: Re: BTRFS deadlock when OOM killed processes using the file system
To: Leo Unbekandt <leo.unbek@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-08-19 17:39 GMT+02:00 Leo Unbekandt <leo.unbek@gmail.com>:
> Hello everyone,
>
> I've encountered what looks like a nasty bug which occures when the OOM
> kills a process and that this process is working with the file system.
> I've been able to reproduce this issue using docker, by limiting the
> memory limits of process and make them crash when working.
>
> (You can find more information there: my post on Docker bug tracker, but
> it seems that it is more a BTRF-related issue
> https://github.com/docker/docker/issues/15654#issuecomment-132384763)
>
> Once the processes have been killed, a BTRFS kworker switched in
> uninterruptible (state D) IO wait, and the file system is completely
> unusable, no way to read or write from it which is pretty critical, in
> my case Docker is not usable anymore as btrfs is the used storage backend.
>
> OOM logs: http://pastebin.com/Lb4Gybay (Simple OOM logs)
> BTRFS freeze and uninterruptible processes (plus Sysrq-w):
> http://pastebin.com/qd1yB8u2
>
> Hoping that I've got enough information, tell me if you need more. Now
> I'm able to reproduce quite easily.

Just a heads up - I'm just a user but I've seen exactly the same
problem (running Java apps like Elasticsearch/Hadoop) when the OOM
killer is triggered.

Looks like you are using Linux 3.19 - but I've seen the issue also on
4.0 and 4.1.

regards
Martin
