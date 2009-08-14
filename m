From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
Date: Fri, 14 Aug 2009 17:35:07 +0100
Message-ID: <tnxab228ibo.fsf@pc1117.cambridge.arm.com>
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932707AbZHNQfS@vger.kernel.org>
In-Reply-To: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com> (Daniel J. Blueman's message of "Fri\, 14 Aug 2009 16\:03\:04 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
> [1] are false-positives, due to the overwriting of the static pointers
> [2]. Does this ring true with anyone else?

If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
disappear?

The static pointers are scanned by kmemleak, unless they are in the
.data.init section (which is removed anyway).

-- 
Catalin
