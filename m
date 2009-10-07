From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 23:12:52 +0200
Message-ID: <200910072312.52729.diegocg@gmail.com>
References: <200910062048.32381.diegocg@gmail.com> <200910072110.28958.diegocg@gmail.com> <20091007194529.GN3757@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007194529.GN3757@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 07 October 2009 21:45:29 Chris Mason escribi=F3:
> I'm afraid this is good old enospc.  Balancing still needs some work =
to
> be completely safe.

I've tried using less data and raid1, but I can't reproduce it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
