From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFB] add LZ4 compression method to btrfs
Date: Tue, 14 Feb 2012 13:13:29 -0800
Message-ID: <m2ipj96ruu.fsf@firstfloor.org>
References: <20120213190325.GJ15350@twin.jikos.cz>
	<loom.20120214T214105-102@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
To: Markus Lindberg <marcuslindberk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120214T214105-102@post.gmane.org> (Markus Lindberg's
	message of "Tue, 14 Feb 2012 20:44:08 +0000 (UTC)")
List-ID: <linux-btrfs.vger.kernel.org>

Markus Lindberg <marcuslindberk@gmail.com> writes:
>
>
> Are you sure about these figures ? the difference seems too large. It's almost
> unbelievable.

Yes, my benchmarks totally disagree with them. In my tests lz4 is
generally slower than snappy-c.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
