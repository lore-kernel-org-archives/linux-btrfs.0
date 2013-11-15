Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49904 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3KONmJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 08:42:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131115134019.3802.51473@localhost.localdomain>
References: <20131114171952.3802.93244@localhost.localdomain>
	<20131115113216.GA7777@osiris>
	<20131115122131.3802.25439@localhost.localdomain>
	<20131115134019.3802.51473@localhost.localdomain>
Date: Fri, 15 Nov 2013 14:42:08 +0100
Message-ID: <CAMuHMdWsEaDKoPy7JhKUGqUrkg_8JrVH7fc8JePt=9MXzcSrgQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 2:40 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Chris Mason (2013-11-15 07:21:31)
>> Quoting Heiko Carstens (2013-11-15 06:32:16)
>> > On Thu, Nov 14, 2013 at 12:19:52PM -0500, Chris Mason wrote:
>> > > Hi Linus,
>> > >
>> > > Please pull my for-linus branch:
>> > >
>> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>> > >
>> > > This is our usual merge window set of bug fixes, performance
>> > > improvements and cleanups.  Miao Xie has some really nice optimizations
>> > > for writeback.
>> > >
>> > > Josef also expanded our sanity checks quite a bit; these make up a big
>> > > chunk of the new lines.
>> >
>> > Hmm..  b19e68439375  "btrfs: Remove redundant local zero structure" seems to
>> > use the empty_zero_page incorrectly and causes this compile warning on s390:
>> >
>> >   CC      fs/btrfs/ioctl.o
>> > fs/btrfs/ioctl.c: In function 'btrfs_is_empty_uuid':
>> > fs/btrfs/ioctl.c:372:2: warning: passing argument 2 of 'memcmp' makes pointer from
>> >                         integer without a cast [enabled by default]
>> >   return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
>> >   ^
>> >
>> > In fact there seem to be two more incorrect usages in the kernel. The patch
>> > below is not really tested.
>>
>> Thanks Heiko,
>>
>> I'll make a new pull with the btrfs part of this.
>
> Or something slightly different ;)
>
> BUG: unable to handle kernel paging request at 0000000001ba6000
> IP: [<ffffffff812b3656>] memcmp+0xf/0x22

I was just going to comment that

+       const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));

won't fly. You can't just cast a physical address to "void *".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
