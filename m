From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: replacing failed disks in RAID-1 (kernel BUG)?
Date: Mon, 13 Jul 2009 14:23:33 +0100
Message-ID: <1247491413.19180.172.camel@macbook.infradead.org>
References: <4A5B0C39.5030905@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A5B0C39.5030905@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-07-13 at 12:28 +0200, Tomasz Chmielewski wrote:
> How do I replace failed disks in RAID-1 mode?

I don't think you can. In theory you can remove the broken one, and you
can add a _new_ empty one -- I say 'in theory' because you seem to have
demonstrated both of those actions failing.

But I don't believe we have yet implemented anything to let you
_replace_ a failed disk and recreate its original contents.

I had that on my TODO list for some time after I get the basic RAID[56]
operation working.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

