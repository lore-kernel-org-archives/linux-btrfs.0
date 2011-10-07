From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v0 07/18] btrfs: generic data structure to build unique lists
Date: Fri, 7 Oct 2011 17:07:06 +0200
Message-ID: <20111007150706.GC14482@one.firstfloor.org>
References: <cover.1317915010.git.sensille@gmx.net> <3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net> <m2y5wx3loj.fsf@firstfloor.org> <4E8EB462.7000908@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8EB462.7000908@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

> As to the differences to idr:
>  - as David pointed out, idr works on int, while I always need u64 to
>    represent btrfs logical addresses.
>  - as I understand idr (though I never used it), it is designed to manage
>    small consecutive integers, while ulists hold completely unrelated
>    numbers, e.g. btrfs logical adresses. For small sets ulists might be
>    much faster than idr
>  - ulists as used here are very short lived. I don't know if idr handles
>    this case well
>  - the purpose of ulists is to add a specific number, and not to find a
>    free one. I don't see a direct interface for this in idr.

Okay. Fair enough.

I would suggest to put it into lib/* and submit it to the mainline
kernel and see what happens.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
