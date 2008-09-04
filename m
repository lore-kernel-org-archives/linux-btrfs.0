From: Steve Long <slong@rathaus.eclipse.co.uk>
Subject: Testsuite
Date: Thu, 4 Sep 2008 20:07:32 +0100
Message-ID: <200809042007.32312.slong@rathaus.eclipse.co.uk>
References: <1219221805.15514.13.camel@telesto> <200808240802.36586.slong@rathaus.eclipse.co.uk> <f058a9c30808251456h4b9df491o787f7305716008b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30808251456h4b9df491o787f7305716008b1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for delay in replying, was on holiday.		
Firstly: thanks for your patience; I was a bit brusque, and for that I must 
apologise.

On Monday 25 August 2008 22:56:50 Miguel Sousa Filipe wrote:
> On Sun, Aug 24, 2008 at 8:02 AM, Steve Long <slong@rathaus.eclipse.co.uk> 
wrote:
> > On Thursday 21 August 2008 11:47:03 Miguel Sousa Filipe wrote:
> >> One thing that I would like to see, is how btrfs behaves with eavy
> >> uses of version control systems like:
> >> - git
> >> - hg
> >>
> >> big repos, greps, finds, and stuff like that.
> >
> > How about kernel compiles (cf contest)? Perhaps with pull of the tree
> > from cold cache or indeed several trees.
>
> I believe Chris allready cover that workload in his tests.. but can't hurt.
> :D
>
More the merrier :-)

> > Not that it's anything to do with the FS, so why should we worry about it?
> >
> even if I like the gentoo or openbsd way, that doesn't help having
> good btrfs support on
> all the other distros that use HAL or its descendants.
>
Sure and I do have HAL running here, I simply don't include anything optional 
for it. I am still unclear as to what the FS living under the VFS has to do 
with the hal layer (and I freely admit this is from ignorance; dbus looked 
quite nice as a protocol when I looked at it fwtw.) Is there anything 
specific that a FS has to do which is not already covered by interfacing 
correctly with the kernel (and providing a useful range of ioctls)?

> > I agree with all the other stuff you posted, so please don't take my
> > antipathy toward HAL and *Kit as criticism of you.
>
> I share much of your opinions about hal and these new (leaky)
> abstraction layers, but having a current/decent linux install without
> all that hal stuff (with gnome or kde) is next to impossible.
>
Agreed.

> My concearn is more of btrfs having equal support on those dandy
> apps/layers, that will be used by fedora, ubuntu, opensuse, etc...
> I want in a years time, have a "format with BTRFS" option on a regular
> fedora/ubuntu install.
>
++ again. I don't see that being an issue if the coders are happy with what 
it's doing under the hood, although of course it needs to be tested more 
widely, and that QA process would shake out what needs work to interface 
nicely with userland (especially wrt recovery/snapshotting and so on, which 
afaict is all planned for some point.)

We can use some of the infra we use for the unofficial hardened Gentoo [1] 
(GCC 4.x) to trac and bugfix a testsuite if that would be of any use. (We'll 
be mirroring it soon.) I have fairly good bash and sh/awk skills fwtw, and 
I'm sure some other users have lots of stuff to contribute. Is that helpful 
(I'm thinking in terms of managing the workload and keeping it off core devs' 
backs since this would pretty much all be scripts) or would it simply be 
unwanted duplication?

If anyone already has a git repo with test stuff, please let us know and we'll 
gladly contribute patches etc. to that.

Regards,
SteveL.

[1] https://hardened.gentooexperimental.org/secure/
