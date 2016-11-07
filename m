Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42735 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbcKGViQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 16:38:16 -0500
Date: Mon, 7 Nov 2016 22:38:10 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make block group flags in balance printks
 human-readable
Message-ID: <20161107213810.GA25649@angband.pl>
References: <20161104072654.13411-1-kilobyte@angband.pl>
 <20161107165841.GQ12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161107165841.GQ12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2016 at 05:58:41PM +0100, David Sterba wrote:
> On Fri, Nov 04, 2016 at 08:26:54AM +0100, Adam Borowski wrote:
> > They're not even documented anywhere, letting users with no recourse but
> > to RTFS.  It's no big burden to output the bitfield as words.
> 
> Ok. Below are some comments (and style nitpicks).

[...]

> > +	char flags_str[128];
> 
> This could be a problem. The relocation can trigger deep call chains
> when doing IO, that need stack. I'd rather avoid the static buffer,
> please switch it to kmalloc.

Are the chains callers or callees of relocation?  I believe exclusively the
latter, as balance is a long process that wouldn't make sense inside a deep
chain -- am I right?  In that case, moving the printk to the display
function would localize the buffer, avoiding all complications of an alloc.

(v2 does alloc)

> As this is not a critical allocation, the fallback would be to print just
> the raw value as now.

If the kernel is that low on memory, is it reasonable to print an
unimportant message?  As I see, lots of btrfs code would just fall over and
die horribly, with BUG_ON or aborting; perhaps skipping the message would
be safer?

(v2 has a fallback message)

> Also, please use snprintf. This would need extra variable to track
> number of already printed chars, but should be easy

M'kay.  Even with all flags on (most are mutually exclusive) we won't get
anywhere close to 128 characters, but paranoia can't hurt.


Meow!
-- 
A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
throw away the fruits (can dump them into a cake, etc), let the drink age
at least 3-6 months.
