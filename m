Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:35633 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab2LBMWQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Dec 2012 07:22:16 -0500
Date: Sun, 2 Dec 2012 12:21:53 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Riccardo Berto <riccardobrt@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RESEND] btrfs corruption / cannot mount
Message-ID: <20121202122153.GK3207@yeono.kjorling.se>
References: <CAHt5hBH6drsjdzudgwgd8hdyRFOXsZqptu3J5y32z=MGxTmhCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHt5hBH6drsjdzudgwgd8hdyRFOXsZqptu3J5y32z=MGxTmhCg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 Dec 2012 09:49 +0100, from riccardobrt@gmail.com (Riccardo Berto):
> I'm a btrfs user since I encountered the ext4 3.6.2 bug and then I
> decided to switch.

> Now it seems to work fine, I will stick with this fs until your needs
> in order to give you logs to better understand what happened.

Glad it worked out for you. I didn't reply because I felt I didn't
know enough to be able to offer any insights.

However, you _are_ aware that btrfs is hardly ready for prime time,
right? If you want stability, then ext3 or ext4 probably are better
choices, despite the kernel 3.6.2 bug. ext3 (and to some extent ext4,
because of its roots in the former) are considered time proven by now
and the tools to work with the file systems are mature; btrfs and
tools are still in heavy development. If you want btrfs's ZFS-like
features and can live with another file system on the root partition
(or lots of fiddling to get it working), want something that is more
ready for prime time and can live with a system that is not purely
Free software, perhaps look into running ZFS through FUSE.

At the very least, if you decide to keep using btrfs, you should make
sure that you have good backups of _everything_ stored on btrfs file
systems. I do believe that everyone is doing their best to avoid bugs
slipping into the code, but that goes for the ext4 developers too.
Nobody _wants_ their name attached to a buggy commit, _particularly_
if that bug causes data loss in production environments.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
