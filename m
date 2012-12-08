Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2LIIrD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 03:47:03 -0500
Message-ID: <50C33AEB.6080701@friedels.name>
Date: Sat, 08 Dec 2012 14:04:43 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: segmentation-fault in btrfsck (git-version)
References: <50BFB3B2.8040405@friedels.name> <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
In-Reply-To: <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

thanks for letting me know.
Indeed it would be good to replace the segmentation Fault by " btrfs 
does not yet know how to handle this condition.
Future refinements of btrfsck will probably include proper error
messages for issues that can't be handled, or perhaps even fix the
error."


> It might be interesting for you to try a newer kernel, and use scrub
> on this volume if you have the two disks RAIDed.
I will try that.

Greetings,
Hendrik



-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
