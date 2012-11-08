Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41997 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab2KHCMb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Nov 2012 21:12:31 -0500
Date: Thu, 8 Nov 2012 13:12:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: cwillu <cwillu@cwillu.com>
Cc: dave@jikos.cz, Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
Subject: Re: (late) REQUEST: Default mkfs.btrfs block size
Message-ID: <20121108021210.GK6434@dastard>
References: <loom.20121031T131532-168@post.gmane.org>
 <20121105160649.GM3102@twin.jikos.cz>
 <CAE5mzvjKaXki3fPXOMVGt_h6XO+a--J_ADU2AYwz3eCWUgp6XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE5mzvjKaXki3fPXOMVGt_h6XO+a--J_ADU2AYwz3eCWUgp6XA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 05, 2012 at 10:25:38AM -0600, cwillu wrote:
> On Mon, Nov 5, 2012 at 10:06 AM, David Sterba <dave@jikos.cz> wrote:
> > On Wed, Oct 31, 2012 at 12:20:39PM +0000, Alex wrote:
> >> As one 'stuck' with 4k leaves on my main machine for the moment, can I request
> >> the btrfs-progs v0.20 defaults to more efficient decent block sizes before
> >> release. Most distro install programs for the moment don't give access to the
> >> options at install time and there seems to be is a significant advantage to 16k
> >> or 32k
> >
> > IMHO this should be fixed inside the installer, changing defaults for a
> > core utility will affect everybody. 4k is the most tested option and
> > thus can be considered "safe for everybody".
> >
> > The installer may let you to enter a shell and create the filesystem by
> > hand, then point it to use it for installation.
> 
> If we know a better setting, we should default to it.  Punting the
> decision to the distro just means I'll spend the next 3 years telling
> people "yeah, distro X doesn't set it to the recommended setting
> (which isn't the mkfs default), and there's no way to change it
> without wiping and reinstalling using manual partitioning blah blah
> blah."

Totally agree - this is the policy that we follow for mkfs.xfs
defaults. i.e. If we know it is better for the majority of
workloads, and we have confidence it's not going to cause lots of
new problems or regressions, then it should be the default setting.

This is also the reason that we can say "use the defaults" to most
questions about "what is optimal?". i.e:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
