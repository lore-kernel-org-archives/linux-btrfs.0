Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60035 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab2FVRCd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 13:02:33 -0400
Date: Fri, 22 Jun 2012 19:02:16 +0200
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: David Sterba <dsterba@suse.cz>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: join DEV_STATS ioctls to one
Message-ID: <20120622170216.GA28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340368239-8152-1-git-send-email-dsterba@suse.cz>
 <4FE49CC4.6030606@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE49CC4.6030606@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2012 at 06:26:44PM +0200, Stefan Behrens wrote:
> I still do not understand your reason and the benefit of your change.
> The reset command and the read command are two completely different
> operations. Therefore I assigned two different ioctl commands. Then you
> can use strace to see which command is sent, and you can also grep the
> sources without additional effort.

I'll try better.

I see the primary purpose to read the device stats.  A standalone stats
reset ioctl does not make much sense, so it should go along with reading
the last state and then reset. So far ok.

.From implementation and interface POV, the reset is a hint how I want
to read the stats, not directly the command.

The switch whether to do the reset or not, as currently implemented, has
to set the ioctl number, while I'd expect to set a flag.

Other concerns are about future adding more flags or reading them back
from kernel. I don't have examples, this is what I base on my experience
that such things happen and then I can only scratch my head 'why didn't
I add just one more byte there'. Spare bytes avoid some of backward
compatibility problems.

As for strace, it could be taught to be verbose and descriptive about
ioctls arguments (the 3rd parameter). Quick example is

$ strace stty sane
...
ioctl(0, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
...

Currently, strace does not know about btrfs-specific ioctls, eg snapshot:

ioctl(3, 0x50009417, 0x7ffff4ae8850)    = 0


david
