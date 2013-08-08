Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3HHWAl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 18:00:41 -0400
Date: Fri, 9 Aug 2013 00:00:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Arne Jansen <sensille@gmx.net>
Cc: Zach Brown <zab@redhat.com>, dsterba@suse.cz,
        Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
Message-ID: <20130808220039.GA5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-7-git-send-email-slyich@gmail.com>
 <520349BA.8080006@gmx.net>
 <20130808132614.GS5284@twin.jikos.cz>
 <20130808174657.GV12314@lenny.home.zabbo.net>
 <5203ED45.3090604@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5203ED45.3090604@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:11:01PM +0200, Arne Jansen wrote:
> On 08/08/13 19:46, Zach Brown wrote:
> >>> even though the function is currently unused, I'm hesitating to remove it
> >>> as it's part of the reada-API and might be handy for anyone going to use
> >>> the API in the future.
> >>
> >> I agree. As replied here,
> >> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html
> >> please keep the function.
> > 
> > If we're keeping score, put me down for being in favour of removing dead
> > untested code.  git ressurection is easy. 
> 
> It's not really untested, it has been in use some time ago. But of
> course there's a chance that some changes broke it.
> Yes, git ressurection is easy. To inform potential users, you might
> just leave a comment like this:
> 
> /*
>  * There has been a function once to detach from a running reada.
>  * If you need such functionality, just revert the commit that
>  * added this comment.
>  */

And please write the exact commit sha1 instead of 'the commit' :)

I've used the _detach function when prototyping readdir readahead, that
did not bring the speedup as expected so more work is needed, that's why
I'm concerned about removing it. But, if Arne is ok with that, so be it.

david
