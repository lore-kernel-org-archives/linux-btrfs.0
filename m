From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with large max_sectors_kb
Date: Fri, 18 Feb 2011 14:16:12 -0500
Message-ID: <1298056463-sup-4453@think>
References: <bug-29302-10286@https.bugzilla.kernel.org/> <20110217153719.9ecc67df.akpm@linux-foundation.org> <20110218174315.GD5615@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	bugzilla-daemon <bugzilla-daemon@bugzilla.kernel.org>,
	bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
	fox <fox@murder.cz>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110218174315.GD5615@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-02-18 12:43:15 -0500:

[ great analysis, thanks so much ]

> 
> Could be, that any of the devices from 'head' list does not satisfy condition
> on line 619, but it cannot be the first device, as !latest_transid would
> work. There is only one device, /dev/sdb, latest_bdev is set and later on
> set on line 660.
> 
> /me sees no more options
> 
> Meanwhile I've tried it myself and the error does not happen here, with
> head at 795abaf1e4e185 (.38-rc4-178-g795abaf). I'll try it with latest -rc5.
> 
> > > [  605.110089] PGD 277d70067 PUD 277e0a067 PMD 0 
> > > [  605.110247] Oops: 0000 [#1] SMP 

Are there any more kernel messages involved before the oops starts?  It
really feels like we're failing to open the block device somehow inside
the btrfs scanning code.

-chris
