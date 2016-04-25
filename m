Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:39503 "EHLO
	corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbcDYKt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 06:49:57 -0400
Subject: Re: btrfs forced readonly + errno=-28 No space left
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
 <CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <071088ea-a850-ee4a-e25a-52dfa24abfdb@zoner.cz>
Date: Mon, 25 Apr 2016 12:49:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne 22.4.2016 v 0:44 Chris Murphy napsal(a):
> On Thu, Apr 21, 2016 at 6:53 AM, Martin Svec <martin.svec@zoner.cz> wrote:
>> Hello,
>>
>> we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No space
>> left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
>> unallocated space:
> Are you snapshotting near the time of enospc?

What do you mean by "near"? Milliseconds, seconds, minutes? In general, yes, but it's hard to say
exactly because multiple backup jobs run in parallel every night.

> If so it's a known problem that's been around for a while. There are some suggestions in
> the archives but I think the main thing is to back off on the workload
> momentarily, take the snapshot, and then resume the workload. I don't
> think it has to come to a complete stop but it's a lot more
> reproducible with heavy writes.

I'm afraid we cannot throttle the workload, due to backup jobs concurrency. I would expect this to
be done at the filesystem level.

Anyway, how can I help to fix this bug? Is there anybody who works on fixing it or is it considered
a "feature"?

Best regards
Martin Svec


