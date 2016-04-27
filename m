Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbcD0RPr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 13:15:47 -0400
Date: Wed, 27 Apr 2016 19:15:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, chandan@mykolab.com
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than
 page size
Message-ID: <20160427171534.GL29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
 <CAL3q7H4+SOxG88RAGAdt+npPJ6nhehwmVySGdGD-dVv9u-h_zQ@mail.gmail.com>
 <1812092.vCqY3YhCNW@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1812092.vCqY3YhCNW@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 08:48:49PM +0530, Chandan Rajendra wrote:
> On Tuesday 26 Apr 2016 14:54:46 Filipe Manana wrote:
> 
> > Hi Chandan,
> > 
> > What does it mean the tests don't pass? Is there absolutely no code
> > changes for scrub and compression, or there is but still needs more
> > working, or what?
> >
> 
> Hi Filipe,
> 
> The patches that have been sent have no changes made with respect to either
> scrub or compression.
> 
> > What happens if, when one is using block size < page size, and enables
> > compression on a single file (i.e. fs not mounted with -o compress or
> > force-compress), we start writing and read to the file? Does it result
> > in the syscalls failing with -EIO or some other error, does it result
> > in crashes (BUG_ON(), etc), dues it result in transparently falling
> > back to non compression mode, or what happens exactly?
> 
> With the current patchset, reading/writing to a compressed file in
> (block size == page size) scenario works fine. However reading/writing to a
> compressed file in (block size < page size) results in crashes.

Lack of support for compression was pre-agreed but chrashes do not seem
ok to me, if there are EINVAL or EOPNOTSUPP erros that would be
acceptable for the first version I think. We will run fstests with this
patchset so if a test fails then we can see if it was due to
compression, but a crash would make testing tedious, manual test
exception needed etc.

> > Same kind of question regarding scrub.
> 
> Scrub works fine for (block size == page size) scenario. However, Scrub ioctl
> returns -EINVAL for the case where block size != page size. Without the block
> size check, scrub might result in crashes.

EINVAL should be ok here.
