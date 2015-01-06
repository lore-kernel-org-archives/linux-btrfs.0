Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbAFOIB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 09:08:01 -0500
Date: Tue, 6 Jan 2015 15:07:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <chris@colorremedies.com>
Subject: Re: [PATCH] btrfs: suppress a build warning on building 32bit kernel
Message-ID: <20150106140759.GA24104@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com>
 <549BD725.8040603@jp.fujitsu.com>
 <20141229150903.GH6490@twin.jikos.cz>
 <54AA4551.9010900@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54AA4551.9010900@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 05, 2015 at 05:03:29PM +0900, Satoru Takeuchi wrote:
> >> -		failrec = (struct io_failure_record *)state->private;
> >> +		failrec = (struct io_failure_record *)(unsigned long)state->private;
> >
> > We're always using the 'private' data to store a pointer to
> > 'struct io_failure_record *', please change the defintion in
> > 'struct extent_state' instead of the typecasting.
> 
> Current definition is as follow.
> 
> ===============================================================================
> struct extent_state {
> ...
>          /* for use by the FS */
>          u64 private;
> };
> ===============================================================================
> 
> It it OK to changing "u64 private" to "struct io_failure_record *failrec"
> and change "{set,get}_state_private()" to "{set,get}_state_failrec()?
> Or is it better to keep the name "private" as is and just change its type
> to "unsigned long" or "(void *)"?

I've looked at the implied changes that set/get functions renaming would
need, also to keep the code sane. It does not seem to be small enough to
fold in this patch so please go on with adding the typecasts. The code
could use some cleanups but bugfixes first.
