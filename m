From: Josef Bacik <josef@redhat.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 15:15:19 -0500
Message-ID: <20110105201518.GD2562@localhost.localdomain>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain> <1294257493.2953.33.camel@havelock.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Gordan Bobic <gordan@bobich.net>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Lars Wirzenius <liw@liw.fi>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294257493.2953.33.camel@havelock.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 07:58:13PM +0000, Lars Wirzenius wrote:
> On ke, 2011-01-05 at 14:46 -0500, Josef Bacik wrote:
> > Blah blah blah, I'm not having an argument about which is better because I
> > simply do not care.  I think dedup is silly to begin with, and online dedup even
> > sillier.  The only reason I did offline dedup was because I was just toying
> > around with a simple userspace app to see exactly how much I would save if I did
> > dedup on my normal system, and with 107 gigabytes in use, I'd save 300
> > megabytes.  I'll say that again, with 107 gigabytes in use, I'd save 300
> > megabytes.  So in the normal user case dedup would have been wholey useless to
> > me.
> 
> I have been thinking a lot about de-duplication for a backup application
> I am writing. I wrote a little script to figure out how much it would
> save me. For my laptop home directory, about 100 GiB of data, it was a
> couple of percent, depending a bit on the size of the chunks. With 4 KiB
> chunks, I would save about two gigabytes. (That's assuming no MD5 hash
> collisions.) I don't have VM images, but I do have a fair bit of saved
> e-mail. So, for backups, I concluded it was worth it to provide an
> option to do this. I have no opinion on whether it is worthwhile to do
> in btrfs.
> 

Yeah for things where you are talking about sending it over the network or
something like that every little bit helps.  I think deduplication is far more
interesting and usefull at an application level than at a filesystem level.  For
example with a mail server, there is a good chance that the files will be
smaller than a blocksize and not be able to be deduped, but if the application
that was storing them recognized that it had the same messages and just linked
everything in its own stuff then that would be cool.  Thanks,

Josef
