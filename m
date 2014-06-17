Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:41793 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215AbaFQVMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 17:12:53 -0400
Date: Tue, 17 Jun 2014 23:12:44 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Russell Coker <russell@coker.com.au>, kreijack@inwind.it,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140617211244.GA2263@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <539BFF47.8060006@libero.it>
 <20140615221307.GE24386@tango.0pointer.de>
 <1709025.rRUgx5gMp1@xev>
 <20140616101448.GB18016@tango.0pointer.de>
 <539F15DC.4010600@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539F15DC.4010600@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16.06.14 09:05, Josef Bacik (jbacik@fb.com) wrote:

> So you are doing all the right things from what I can tell, I'm just
> a little confused about when you guys run fsync.  From what I can
> tell it's only when you open the journal file and when you switch it
> to "offline."  I didn't look too much past this point so I don't
> know how often these things happen.  Are you taking an individual
> message, writing it, updating the head of the file and then
> fsync'ing?  Or are you getting a good bit of dirty log data and
> fsyncing occasionally?

The latter. Basically when opening a file for writing we mark it in the
header as "online", then fsync() it. When we close a file we fsync() it,
then change the header to "offline", ans sync() again. Also, 5min after
each write we will also put things to offline, until the next write,
when we will put things to online again. Finally, if something is logged
at priorities EMERG, ALERT or CRIT we will sync immediately (which
actually should never happen in real-life, unless something is really
broken -- a simple way to check if anything like this got written is
"journalctl -p crit").

Also, we rotate and start a new file every now and then, when we hit a
size limit, but that is usually very seldom.

Putting this together: we should normally fsync() only very
infrequently. 

> What would cause btrfs problems is if you fallocate(), write a small
> chunk, fsync, write a small chunk again, fsync again etc.  Fallocate
> saves you the first write around, but if the next write is within
> the same block as the previous write we'll end up triggering cow and
> enter fragmented territory.  If this is what is what journald is
> doing then that would be good to know, if not I'd like to know what
> is happening since we shouldn't be fragmenting this badly.

Hmm, the only way I see that that would happen is if a lot of stuff is
logged at these super-high log levels mentioned above. But then again,
that never really should happen in real-life.

Could anyone who's expereiencing the slowdowns have a look on the
journalctl output menionted above? Do you have more than a few lines
printed like that?

Lennart

-- 
Lennart Poettering, Red Hat
