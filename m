Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753142AbdGLWyt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:54:49 -0400
Date: Thu, 13 Jul 2017 00:53:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Enable ThreadSanitizer, using D=tsan.
Message-ID: <20170712225335.GU2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170712200449.18638-1-abuchbinder@google.com>
 <20170712215122.GK2866@twin.jikos.cz>
 <CALb+jKoe8U5XdnPT1KnYsJBezrk=FcsbEsu3+ibT+Xv8gOhp=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALb+jKoe8U5XdnPT1KnYsJBezrk=FcsbEsu3+ibT+Xv8gOhp=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 03:45:46PM -0700, Adam Buchbinder wrote:
> On Wed, Jul 12, 2017 at 2:51 PM, David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Jul 12, 2017 at 01:04:49PM -0700, Adam Buchbinder wrote:
> > > Tested with clang-3.9.
> > >
> > > Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> > > ---
> > >  Makefile | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/Makefile b/Makefile
> > > index 81598df..8948301 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -17,6 +17,7 @@
> > >  #                  abort   - call abort() on first error (dumps core)
> > >  #                  all     - shortcut for all of the above
> > >  #                  asan    - enable address sanitizer compiler feature
> > > +#                  tsan    - enable thread sanitizer compiler feature
> > >  #                  ubsan   - undefined behaviour sanitizer compiler
> feature
> > >  #                  bcheck  - extended build checks
> > >  #   W=123          build with warnings (default: off)
> > > @@ -157,6 +158,11 @@ ifneq (,$(findstring asan,$(D)))
> > >    DEBUG_CFLAGS_INTERNAL += -fsanitize=address
> > >  endif
> > >
> > > +ifneq (,$(findstring tsan,$(D)))
> > > +  DEBUG_CFLAGS_INTERNAL += -fsanitize=thread -fPIE
> > > +  LD_FLAGS += -fsanitize=thread -ltsan -pie
> >
> > Why do you need to set PIE here? Is is necessary for tsan?
> 
> Yes; see https://clang.llvm.org/docs/ThreadSanitizer.html:
> "Non-position-independent executables are not supported."

Thanks, patch applied.
