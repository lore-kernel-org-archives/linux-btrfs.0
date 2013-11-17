Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab3KQJgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 04:36:19 -0500
Date: Sun, 17 Nov 2013 11:36:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20131117093604.GT2008@redhat.com>
References: <20131114171952.3802.93244@localhost.localdomain>
 <20131115113216.GA7777@osiris>
 <20131115122131.3802.25439@localhost.localdomain>
 <20131115134019.3802.51473@localhost.localdomain>
 <CAMuHMdWsEaDKoPy7JhKUGqUrkg_8JrVH7fc8JePt=9MXzcSrgQ@mail.gmail.com>
 <20131115145723.GB7777@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131115145723.GB7777@osiris>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 03:57:23PM +0100, Heiko Carstens wrote:
> On Fri, Nov 15, 2013 at 02:42:08PM +0100, Geert Uytterhoeven wrote:
> > On Fri, Nov 15, 2013 at 2:40 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> > > Quoting Chris Mason (2013-11-15 07:21:31)
> > >> Quoting Heiko Carstens (2013-11-15 06:32:16)
> > >> > On Thu, Nov 14, 2013 at 12:19:52PM -0500, Chris Mason wrote:
> > >> > > Hi Linus,
> > >> > >
> > >> > > Please pull my for-linus branch:
> > >> > >
> > >> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > >> > >
> > >> > > This is our usual merge window set of bug fixes, performance
> > >> > > improvements and cleanups.  Miao Xie has some really nice optimizations
> > >> > > for writeback.
> > >> > >
> > >> > > Josef also expanded our sanity checks quite a bit; these make up a big
> > >> > > chunk of the new lines.
> > >> >
> > >> > Hmm..  b19e68439375  "btrfs: Remove redundant local zero structure" seems to
> > >> > use the empty_zero_page incorrectly and causes this compile warning on s390:
> > >> >
> > >> >   CC      fs/btrfs/ioctl.o
> > >> > fs/btrfs/ioctl.c: In function 'btrfs_is_empty_uuid':
> > >> > fs/btrfs/ioctl.c:372:2: warning: passing argument 2 of 'memcmp' makes pointer from
> > >> >                         integer without a cast [enabled by default]
> > >> >   return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
> > >> >   ^
> > >> >
> > >> > In fact there seem to be two more incorrect usages in the kernel. The patch
> > >> > below is not really tested.
> > >>
> > >> Thanks Heiko,
> > >>
> > >> I'll make a new pull with the btrfs part of this.
> > >
> > > Or something slightly different ;)
> > >
> > > BUG: unable to handle kernel paging request at 0000000001ba6000
> > > IP: [<ffffffff812b3656>] memcmp+0xf/0x22
> > 
> > I was just going to comment that
> > 
> > +       const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));
> > 
> > won't fly. You can't just cast a physical address to "void *".
> 
> Ouch.. I think that only works on s390 because we have a 1:1 mapping for
> physical to virtual addresses in kernel space due to our split address spaces.
> 
> So for btrfs and kvm it should be page_to_virt(), and for the dma_map_single()
> case I have no idea. :)
Can you send updated patch for kvm please?

--
			Gleb.
