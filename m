From: Morey Roof <moreyroof@gmail.com>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 13:45:56 -0600
Message-ID: <1218656756.5907.7.camel@sdevel.nmt.edu>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
	 <55868.206.174.215.6.1218655701.squirrel@avalon.arbitraryconstant.com>
	 <a5e060610808131235n8d57cabye8607c4fd0a7d984@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
To: btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a5e060610808131235n8d57cabye8607c4fd0a7d984@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

It is the same idea for the way space efficient snapshots work currently
in btrfs.  I'm just planning out a way to make a process got find them
and link them together and increase the reference counts and another
method for having the allocator do it while writing.

-Morey


On Wed, 2008-08-13 at 12:35 -0700, Kevin Cantu wrote:
> This would be a kind of filesystem block level compression, right?
> 
> On Wed, Aug 13, 2008 at 12:28 PM,  <btrfs-devel@arbitraryconstant.com> wrote:
> >> Don't do it!!!
> >>
> >> OK, I know Chris has described some block sharing.  But I hate it.
> >>
> >> If I copy "resume" to "resume.save", it is because I want 2 copies
> >> for safety.  I don't want the fs to reduce it to 1 copy.  And
> >> reducing the duplicates is exactly opposite to Chris's paranoid
> >> make-multiple-copies-by-default.
> >>
> >> Now feel free to tell me I'm an idiot (other people do) :)
> >
> > In situations where there's non-trivial benefits to some workloads, but
> > also non-trivial drawbacks, it strikes me as something that could be
> > enabled and disabled as a mount option, like data=ordered.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

