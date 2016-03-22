Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56674 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbcCVCYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 22:24:17 -0400
Date: Mon, 21 Mar 2016 22:24:13 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20160322022412.zpsdrxiocoivcnwg@floor.thefacebook.com>
References: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
 <CA+55aFzkbk=EVjqp6cx+OQXPadFGfFvaHHV59+CZFStFB8gGvQ@mail.gmail.com>
 <20160322021533.xqalzzk5itglqu3x@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160322021533.xqalzzk5itglqu3x@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 10:15:33PM -0400, Chris Mason wrote:
> On Mon, Mar 21, 2016 at 06:16:54PM -0700, Linus Torvalds wrote:
> > On Mon, Mar 21, 2016 at 5:24 PM, Chris Mason <clm@fb.com> wrote:
> > >
> > > I waited an extra day to send this one out because I hit a crash late
> > > last week with CONFIG_DEBUG_PAGEALLOC enabled (fixed in the top commit).
> > 
> > Hmm. If that commit helps, it will spit out a warning.
> > 
> > So is it actually fixed, or just hacked around to the point where you
> > don't get a page fault?

Hmmm, rereading my answer I realized I didn't actually answer.  I really
think this is fixed.  I left the warning only because I originally
expected something much more exotic.

-chris
