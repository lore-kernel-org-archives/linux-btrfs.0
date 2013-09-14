Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:46132 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3INJdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Sep 2013 05:33:49 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Sat, 14 Sep 2013 10:26:35 +0100
Date: Sat, 14 Sep 2013 11:33:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Russell King <rmk@arm.linux.org.uk>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130914093343.GA5094@osiris>
References: <20130912153629.16487.88969@localhost.localdomain>
 <CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com>
 <CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com>
 <CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
 <20130913121529.GA1437@flint.arm.linux.org.uk>
 <CA+5PVA6Qon0cskv5wDyiCxSZzc2WjUFmzYmGE0zoNJC5ms1-XQ@mail.gmail.com>
 <CA+5PVA4NAmFnc3s6CaaDow9P3xLXOiEngHjQ_P5+TEG--LZ9ZQ@mail.gmail.com>
 <20130913155835.GA9697@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130913155835.GA9697@flint.arm.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 04:58:36PM +0100, Russell King wrote:
> On Fri, Sep 13, 2013 at 11:38:15AM -0400, Josh Boyer wrote:
> > On Fri, Sep 13, 2013 at 11:06 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> > > On Fri, Sep 13, 2013 at 8:15 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> > >> On Fri, Sep 13, 2013 at 07:53:21AM -0400, Josh Boyer wrote:
> > >>> I'm not an ARM expert, so I don't know if ARM should use the
> > >>> asm-generic implementations, or just use __get_user/__put_user in all
> > >>> cases.  I've CC'd rmk.
> > >>
> > >> Why do we have uaccess-unaligned.h ?  Normally, these kinds of things
> > >> are spawned by architectures which have problems with unaligned accesses,
> > >> ARM being one of them, but afaik we've never need this.
> > >>
> > >> With the kernel-side trapping of unaligned accesses on older hardware,
> > >> we've always dealt with the normal accessor faulting.
> > >>
> > >> From what I can tell in the git history, these unaligned put_user and
> > >> get_user have existed all the way back to the dawn of git use.
> > >>
> > >> Can someone enlighten me why we have them?
> > 
> > I somehow fail at email and dropped Russell from CC on accident.  Sigh.
> 
> You're not the first to do that recently.  I'm beginning to think it's
> something someone has written into email clients to make them do in order
> to piss me off.  I mean, it's _hard_ to do - you have to manually edit the
> recipients list to just drop one person.

You configured your mail client to generate a "Mail-Followup-To:" header
field which actively asks other mail clients to remove you from replies.
So you only get what you ask for... ;)

I think the mutt "metoo" variable will change that, but I don't know
for sure.

