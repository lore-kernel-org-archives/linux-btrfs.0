From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 15:51:46 +0200
Message-ID: <200910071551.46430.diegocg@gmail.com>
References: <200910062048.32381.diegocg@gmail.com> <20091007031754.GB3757@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007031754.GB3757@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 07 October 2009 05:17:54 Chris Mason escribi=F3:

> Thanks, I'll try to reproduce.  Which raid level did you use for data=
?
> If not raid1, could you try with raid1? ;)

I'm not sure, since the utils won't tell. I mkfs'ed and mounted one of =
the 3.5GB
files with no special options, and copied some files on it. I mkfs'ed t=
he second
file, put it in a loop device, and added it to the pool with btrfs-vol =
-a. Then
I run btrfs-vol -b and I copied more files and rebalanced several times=
=2E

Then I zeroed one of the files used as disks, and tried to read the fil=
es in
the volume (unsucessfully). Then I rebalanced, and I hit the oops. It s=
eems to
be very reproducible.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
