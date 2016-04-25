Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:40619 "EHLO
	corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbcDYKxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 06:53:10 -0400
Subject: Re: btrfs forced readonly + errno=-28 No space left
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
 <CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
 <CAD=QJKhDJ+OgwJXUv3Rizzs4jFtzt=4HwD9b7E6y324fd_vVHQ@mail.gmail.com>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <c08f68be-4a15-4a71-dea4-529511a0d343@zoner.cz>
Date: Mon, 25 Apr 2016 12:53:07 +0200
MIME-Version: 1.0
In-Reply-To: <CAD=QJKhDJ+OgwJXUv3Rizzs4jFtzt=4HwD9b7E6y324fd_vVHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne 22.4.2016 v 23:00 Nicholas D Steeves napsal(a):
> On 21 April 2016 at 18:44, Chris Murphy <lists@colorremedies.com> wrote:
>> On Thu, Apr 21, 2016 at 6:53 AM, Martin Svec <martin.svec@zoner.cz> wrote:
>>> Hello,
>>>
>>> we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No space
>>> left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
>>> unallocated space:
>> Are you snapshotting near the time of enospc? If so it's a known
>> problem that's been around for a while. There are some suggestions in
>> the archives but I think the main thing is to back off on the workload
>> momentarily, take the snapshot, and then resume the workload. I don't
>> think it has to come to a complete stop but it's a lot more
>> reproducible with heavy writes.
> Is this known problem specific to heavy writes + take a snapshot + -o
> compress (either zlib or lzo), or does this enospc also affect the
> more simple heavy writes + take a snapshot case?  Is there a greater
> likelyhood of running into it if using compression?

In our case, I saw no difference when the compression was disabled.

Martin Svec

