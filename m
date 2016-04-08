Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:55123 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbcDHLvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 07:51:44 -0400
Subject: Re: WARN_ON in record_root_in_trans() when deleting freshly renamed
 subvolume
To: fdmanana@gmail.com
References: <57068E64.7000408@googlemail.com>
 <CAL3q7H6U8hDK7+BOqP-u3ogrJaKxED3U839kmT_PU6kbq9U1AA@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <57079B4D.8080304@googlemail.com>
Date: Fri, 8 Apr 2016 13:51:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6U8hDK7+BOqP-u3ogrJaKxED3U839kmT_PU6kbq9U1AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/16 13:14, Filipe Manana wrote:
> Using Chris' for-linus-4.6 branch, which is 4.5-rc6 + all 4.6 btrfs
> patches, it didn't reproduce here:

Great, that's good to know (sort of :). Thanks also to Liu Bo.

> Are you sure that you are not using some patches not in 4.6?

Quite a few, but to offset that I also left out some that have diverged
too much or were not that important (block/sectorsize, device handling).
But those should not have anything to do with this particular bug.

Except for this everything works rock-solid, I use it daily.
Should be easy to track down..

-h

