From: Chris Mason <chris.mason@oracle.com>
Subject: Re: lockdep warnings
Date: Tue, 16 Nov 2010 09:37:11 -0500
Message-ID: <1289918184-sup-2354@think>
References: <20101115125129.07f3882d@nehalam>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101115125129.07f3882d@nehalam>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephen Hemminger's message of 2010-11-15 15:51:29 -0500:
> Running with lockdep I see these warnings (running 2.6.37-rc1)
> 
> It occurred during the time when rsync is running backup.

These are false positives, I'll try to fix up the annotations.

-chris
