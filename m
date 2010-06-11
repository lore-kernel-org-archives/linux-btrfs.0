From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Date: Fri, 11 Jun 2010 15:48:12 -0400
Message-ID: <20100611194812.GD3018@think>
References: <20100611193731.GA3018@think>
 <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 11, 2010 at 12:43:10PM -0700, Linus Torvalds wrote:
> On Fri, Jun 11, 2010 at 12:37 PM, Chris Mason <chris.mason@oracle.com> wrote:
> >
> > The master branch of the btrfs-unstable tree is a collection of fixes
> > and cleanups, including two btrfs regressions from rc1:
> 
> Ok, no pulling then. See all the millions of threads how I wanted only
> critical fixes for -rc3 since I'll be offline.
> 
> You have a couple of hours for a minimal fix pull request with just
> the regression fixes if you want to hit -rc3. Then I'll cut a release
> and be gone for a while.

I did limit this to actual fixes, the only pure cleanups are a commit
from Andi that drops unused code (fixing warnings from gcc), one to fix
a sparse warning in ioctl.c, and fixing a gcc warning in tree_search.

The others all fix oopsen or big problems, and I think fixing warnings
helps avoid false negatives as others look for real problems?

I'm happy to rebase out the 3 non-criticals.

-chris
