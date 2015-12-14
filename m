Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37727 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbLNTeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 14:34:04 -0500
Received: by igcto18 with SMTP id to18so90669478igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 11:34:03 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>, dsterba@suse.cz,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz> <566F016D.8050403@gmail.com>
 <1450120614.6629.34.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566F199A.5030704@gmail.com>
Date: Mon, 14 Dec 2015 14:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <1450120614.6629.34.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 14:16, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 12:50 -0500, Austin S. Hemmelgarn wrote:
>> It should also imply noatime.  I'm not sure how BTRFS handles atime
>> when
>> mounted RO, but I know a lot of old UNIX systems updated atime even
>> on
>> filesystems mounted RO, and I know that at least at one point Linux
>> did too.
> I stumbled over that recently myself, and haven't bothered to try it
> out, yet.
> But Duncan's argument, why at least ro-snapshots (yes I know, this may
> not be exactly the same as RO mount option) would need to imply
> noatime, is pretty convincing. :)
The traditional reasoning was that read-only meant that users couldn't 
change anything, not that the actual data on disk wouldn't change. 
That, and there's been some really brain-dead software over the years 
that depended on atimes being right (now, the only remaining software I 
know of that even uses them at all is Mutt).
>
> Anyway, if it "ro" wouldn't imply noatime, I would ask why, because the
> atime is definitely something the fs exports normally to userland,...
> and that's how I'd basically consider hard-ro vs. (soft-)ro:
>
> soft-ro: data as visible by the mounted fs must not change (unless
>           perhaps for necessary repair/replay operations to get the
>           filesystem back in a consistent state)
> hard-ro: soft-ro + nothing on the backing devices may change (bitwise)
This should be 'Nothing on the backing device may change as a result of 
the FS', nitpicking I know, but we should be specific so that we 
hopefully avoid ending up in the same situation again.

