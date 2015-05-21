Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbbEUL4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 07:56:53 -0400
Date: Thu, 21 May 2015 13:56:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
Message-ID: <20150521115651.GP23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
 <CANBHLUhme-Y1FP21yQZ3w6QQCvOTNrXDmNKDRRY8rsMtbDJwuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANBHLUhme-Y1FP21yQZ3w6QQCvOTNrXDmNKDRRY8rsMtbDJwuQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 09:19:59AM +0100, Dimitri John Ledkov wrote:
> On 15 May 2015 at 21:28, Dimitri John Ledkov <dimitri.j.ledkov@intel.com> wrote:
> > Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=784911
> > Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
> > ---
> >  fsck.btrfs | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fsck.btrfs b/fsck.btrfs
> > index f056a7f..3a92804 100755
> > --- a/fsck.btrfs
> > +++ b/fsck.btrfs
> > @@ -31,7 +31,7 @@ if [ ! -e $DEV ]; then
> >         echo "$0: $DEV does not exist"
> >         exit 8
> >  fi
> > -if [ "$AUTO" == "false" ]; then
> > +if [ "false" = "$AUTO" ]; then
> >         echo "If you wish to check the consistency of a BTRFS filesystem or"
> >         echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
> >  fi
> 
> There was a lot of discussion about this trivial patch, mostly because
> it's so trivial and has many ways to fix.
> 
> I hope btrfs maintainers could implement & push any of the proposed
> ways to resolve this bashism to rule them all =)

If you're ok to do

if ! $AUTO...

with your signed-off, then I'll add the patch. I was not comfortable to
do it right away.
