From: Lars Wirzenius <liw@liw.fi>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 21:07:09 +0000
Message-ID: <1294261629.2953.37.camel@havelock.lan>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
	 <4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>
	 <1294257493.2953.33.camel@havelock.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294257493.2953.33.camel@havelock.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On ke, 2011-01-05 at 19:58 +0000, Lars Wirzenius wrote:
> (For my script, see find-duplicate-chunks in
> http://code.liw.fi/debian/pool/main/o/obnam/obnam_0.14.tar.gz or get the
> current code using "bzr get http://code.liw.fi/obnam/bzr/trunk/".
> http://braawi.org/obnam/ is the home page of the backup app.)

If I may add: it would perhaps be good to collect numbers on the amount
of duplication (for various block sizes) there is on different kinds of
systems: random laptops, file servers for small companies and large
companies, mail servers, backup servers, VM servers, etc. Would anyone
be interested in collecting such numbers? A script like mine would be a
bit heavy to run, but not too much so, I bet.

It would be good to have hard numbers as a basis of discussion rather
than guesses and assumptions.

Or perhaps someone's already collected the data?

-- 
Blog/wiki/website hosting with ikiwiki (free for free software):
http://www.branchable.com/

