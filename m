From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warnings and crash
Date: Wed, 2 Nov 2011 19:40:58 -0400
Message-ID: <20111102234058.GH18900@shiny>
References: <20111101024957.GH4468@shiny>
 <20111101125654.GF12759@twin.jikos.cz>
 <20111102230231.GM12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111102230231.GM12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2011 at 12:02:31AM +0100, David Sterba wrote:
> This one happened again, exactly same sequence of warnings and the crash
> at the end (same stack traces). It was in integration-scrub branch, ie.
> with all fixes on top.
> 
> (I have captured sysrq-w, /proc/pid/stack of all processes and have the
> dmesg logs if anybody is interested.)

Yes, I'd like to see the logs.  We need to figure out if we just failed
with enospc in a critical spot or if there are other bigger problems.

-chris

