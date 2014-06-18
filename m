Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45338 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaFROmc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 10:42:32 -0400
Date: Wed, 18 Jun 2014 07:42:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: Transaction commit: none (default)
Message-ID: <20140618144230.GC19071@merlins.org>
References: <20140614160554.GP6584@merlins.org> <539E49DB.80305@cn.fujitsu.com> <20140616014739.GB19071@merlins.org> <pan.2014.06.16.07.06.08@googlemail.com> <539E9841.8040108@cn.fujitsu.com> <20140618141932.GV23096@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140618141932.GV23096@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 04:19:32PM +0200, David Sterba wrote:
> On Mon, Jun 16, 2014 at 03:09:53PM +0800, Wang Shilong wrote:
> > >>>>1) Is that expected/normal? It looks kind of spamming/useless to me?
> > >>>>2) If it's useful, what's the use I'm not getting?
> > >>>Addressed a issue that subvolumes reappear after deletetion if poweroff
> > >>>happen.
> > >>>
> > >>>http://www.spinics.net/lists/linux-btrfs/msg29547.html
> > >>I see, thank you for the pointer.
> > >>In the case of my script, it's console spam that I wish I could make go
> > >>away, but grep -v will do that for me :)
> > >>
> > >>If it annoys other people, maybe having a -q (quiet) that removes this
> > >>message would be useful?
> > >IMHO it should be the reverse: be quiet by default and require -v, just
> > >as more explicit behaviour also requires additional options.
> > >With default options I expect default behaviour. Telling me that the
> > >default behaviour happened is just noise.
> > Fair point, Another question is that current default output has been there.
> > Let's Cc David, and see what is his opinion.
> 
> I agree the way it's now (2 lines of output per 1 subvolume) is not
> good, but I'd like to keep the information about the commit mode, even
> for the default one. So would something like this work?
> 
> current:
> Delete subvolume '/mnt/subvol'
> 
> new:
> Delete subvolume (no commit): '/mnt/subvol'
> 
> or
> Delete subvolume (commit): '/mnt/subvol'

I like this. The old line telling me it did what I just asked it to was kind
of redundant (rm doesn't tell me "I just deleted the file you just asked me
to" unless I use -v, and neither does rmdir).

So making the single line of output more useful would alleviate that a bit.
Although in general and in the future a command should indeed not be verbose
and reply "I just did what yo asked me to" :)
(just for the record, 

Note that my crontabs already have stuff like this. I really wish I didn't
need them, and hope I don't have to extend the egrep line:
btrfs-snaps weekly 2 varlocalspace | egrep -v '(Create a snapshot of|Delete subvolume)'

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
