From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v0 03/18] btrfs: add nested locking mode for paths
Date: Thu, 06 Oct 2011 13:36:01 -0700
Message-ID: <m2ty7l3lji.fsf@firstfloor.org>
References: <cover.1317915010.git.sensille@gmx.net>
	<55d5758142bf964aefbbaadc2188f66ca178f876.1317915010.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <55d5758142bf964aefbbaadc2188f66ca178f876.1317915010.git.sensille@gmx.net>
	(Arne Jansen's message of "Thu, 6 Oct 2011 17:54:13 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille@gmx.net> writes:

> This patch adds the possibilty to read-lock an extent
> even if it is already write-locked from the same thread.
> Subvolume quota needs this capability.

Recursive locking is generally strongly discouraged, it causes all kinds
of problems and tends to eventuall ylead to locking hierarchies nobody
can understand anymore.

If you can find any other way to solve this problem I would
encourage you to do so.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
