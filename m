Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:58098 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbcCLT55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 14:57:57 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aepfX-000783-3l
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 20:57:47 +0100
Date: Sat, 12 Mar 2016 20:57:46 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160312195746.GJ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> Something is happening with the usage of this file system that's out
> of the ordinary. This is the first time I've seen such a large amount
> of unused metadata allocation. And then for it not only fail to
> balance, but for the allocation amount to increase is a first. So
> understanding the usage is important to figuring out what's happening.
> I'd file a bug and include as much information on how the fs got into
> this state as possible. And also if possible make a btrfs-image using
> the proper flags to blot out the filenames for privacy. And what
> btrfs-progs tools were used to create this file system. Etc.

https://bugzilla.kernel.org/show_bug.cgi?id=114451

Please advise if there is something missing.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
