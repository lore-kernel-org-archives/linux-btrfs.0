Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp03.srv.cs.cmu.edu ([128.2.217.202]:58447 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LQTEe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 14:04:34 -0500
Message-ID: <1387305925.25257.37.camel@destiny.pc.cs.cmu.edu>
Subject: Re: [OpenAFS-devel] Re: What is needed to build an AFS fileserver
 on top of BTRFS?
From: Jeffrey Hutzelman <jhutz@cmu.edu>
To: David Howells <dhowells@redhat.com>
Cc: jhutz@cmu.edu, Hugo Mills <hugo@carfax.org.uk>,
        Simon Wilkinson <simonxwilkinson@gmail.com>,
        jaltman@your-file-system.com,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Date: Tue, 17 Dec 2013 13:45:25 -0500
In-Reply-To: <17945.1387302478@warthog.procyon.org.uk>
References: <20131217172002.GE11281@carfax.org.uk>
	 <14884.1387299196@warthog.procyon.org.uk>
	 <17945.1387302478@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-12-17 at 17:47 +0000, David Howells wrote:
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > >  (1) 64-bit data version numbers that increase monotonically with
> > > each write. Yes, this is likely to cause some performance
> > > degredation as it introduces an ordering over data writes and
> > > metadata writes to a file. Maybe writes can be batched to improve
> > > performance?
> > 
> >    Do these have to be per-file? If not, then you might be able to get
> > away with using the transid, which is a filesystem-global
> > monotonically-increasing number.
> 
> Yes.  If you send a write RPC op to the server, you get back the new version
> number.  If the new version number is not the old version number + 1 you know
> there was a collision with a write from another client and you have to flush
> your cache for that file and request a new "callback" (ie. a promise to notify
> you if someone else changes the file).

Right.  So, the DV must increment by exactly one for each successful
StoreData (and not for other changes).  This is important because
clients cache data and metadata independently, and cached data is
labeled with the file's DV.  This means that even if metadata for a file
has to be refetched for some reason (for example, an expired callback),
the _data_ doesn't have to be refetched unless it has actually changed,
or been evicted from the client's cache due to cache pressure.

-- Jeff

