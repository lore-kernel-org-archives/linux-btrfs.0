Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:49088 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3DOG4Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:56:25 -0400
Message-ID: <516BA498.8090807@jan-o-sch.net>
Date: Mon, 15 Apr 2013 08:56:24 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net> <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net> <20130410164741.GS18193@twin.jikos.cz> <516B93C3.4080306@jan-o-sch.net> <516B9701.9040409@jan-o-sch.net> <516B9968.90701@cn.fujitsu.com>
In-Reply-To: <516B9968.90701@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, April 15, 2013 at 08:08 (+0200), Wang Shilong wrote:
> Hello Jan,
> 
>> On Mon, April 15, 2013 at 07:44 (+0200), Jan Schmidt wrote:
>>> Thanks, v2 to come.
>>
>> Uh, but not immediately. I didn't get tracking of "exclusive" right. That will
>> need some time to fix and test.
> 
> 
> 'exclusive' adds the complexity of btrfs qgroup.
> So if you send V2. I'd like you add more lines in changelog.

Yes, the commit message will be longer as you requested previously. This does
not include a complete description on how "exclusive" works. The qgroup pdf
explains that.

> Besides, i have a question in my mind.(I have not seen you code)..
> When qgroup rescan  will happen?
> 
> 1> when quota is enabled

That's what the second patch does, yes. Your patches should be merged in a way
that we first create the level 0 qgroups for all subvolumes and then start the
rescan, obviously.

> 2> if a new qgroup relations is created, rescan should happen?

With your patches, there will be no subvolume qgroups missing. For the higher
level groups, one needs expert knowledge anyway. I think it's best to leave that
decision to the administrator configuring those qgroups.

> 2> user call qgroup rescan..

Of course, yes.

-Jan
