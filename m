Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39581 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbaFROUA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:00 -0400
Date: Wed, 18 Jun 2014 16:19:32 +0200
From: David Sterba <dave@jikos.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org, Marc MERLIN <marc@merlins.org>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: Transaction commit: none (default)
Message-ID: <20140618141932.GV23096@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20140614160554.GP6584@merlins.org>
 <539E49DB.80305@cn.fujitsu.com>
 <20140616014739.GB19071@merlins.org>
 <pan.2014.06.16.07.06.08@googlemail.com>
 <539E9841.8040108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539E9841.8040108@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 03:09:53PM +0800, Wang Shilong wrote:
> >>>>1) Is that expected/normal? It looks kind of spamming/useless to me?
> >>>>2) If it's useful, what's the use I'm not getting?
> >>>Addressed a issue that subvolumes reappear after deletetion if poweroff
> >>>happen.
> >>>
> >>>http://www.spinics.net/lists/linux-btrfs/msg29547.html
> >>I see, thank you for the pointer.
> >>In the case of my script, it's console spam that I wish I could make go
> >>away, but grep -v will do that for me :)
> >>
> >>If it annoys other people, maybe having a -q (quiet) that removes this
> >>message would be useful?
> >IMHO it should be the reverse: be quiet by default and require -v, just
> >as more explicit behaviour also requires additional options.
> >With default options I expect default behaviour. Telling me that the
> >default behaviour happened is just noise.
> Fair point, Another question is that current default output has been there.
> Let's Cc David, and see what is his opinion.

I agree the way it's now (2 lines of output per 1 subvolume) is not
good, but I'd like to keep the information about the commit mode, even
for the default one. So would something like this work?

current:
Delete subvolume '/mnt/subvol'

new:
Delete subvolume (no commit): '/mnt/subvol'

or
Delete subvolume (commit): '/mnt/subvol'

Where the modes of commit (none, each) would stick to each line, and the
'commit after last' would say 'commit' for the last one. Ie. no separate
line that mentions the commit mode globally.
