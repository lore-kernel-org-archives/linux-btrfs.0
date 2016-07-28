Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbcG1K4P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 06:56:15 -0400
Date: Thu, 28 Jul 2016 12:55:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
Message-ID: <20160728105555.GR30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net>
 <CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 01:19:01PM -0400, Nicholas D Steeves wrote:
> > In that regard a defrag -t 32M recommendation is reasonable for a
> > converted filesystem, tho you can certainly go larger... to 1 GiB as I
> > said.
> 
> I only mentioned btrfs-convert.asciidoc, because that's what led me to
> the discrepancy between the default target extent size value, and a
> recommended value.  I was searching for everything I could find on
> defrag, because I had begun to suspect that it wasn't functioning as
> expected.

Historically, the 256K size is from kernel. Defrag can create tons of
data to write and this is noticeable on the system. However the results
of defragmentation are not satisfactory to the user so the recommended
value is 32M. I'd rather not change the kernel default but we can
increase the default threshold (-t) in the userspace tools.

> Is there any reason why defrag without -t cannot detect and default to
> the data chunk size, or why it does not default to 1 GiB?

The 1G value wouldn't be reached on an average filesystem where the free
space is fragmented, besides there are some smaller internal limits on
extent sizes that may not reach the user target size.  The value 32M has
been experimentally found and tested on various systems and it proved to
work well. With 64M the defragmentation was less successful but as it's
only a hint, it's not wrong to use it.

> In the same
> way that balance's default behaviour is a full balance, shouldn't
> defrag's default behaviour defrag whole chunks?  Does it not default
> to 1 GiB because that would increase the number of cases where defrag
> unreflinks and duplicates files--leading to an ENOSPC?

Yes, this would also happen, unless the '-f' option is given (flush data
after defragmenting each file).

> https://github.com/kdave/btrfsmaintenance/blob/master/btrfs-defrag.sh
> uses -t 32M ; if a default target extent size of 1GiB is too radical,
> why not set it it 32M?  If SLED ships btrfsmaintenance, then defrag -t
> 32M should be well-tested, no?

It is.
