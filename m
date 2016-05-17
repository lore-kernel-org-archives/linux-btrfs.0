Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbcEQMXz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 08:23:55 -0400
Date: Tue, 17 May 2016 14:23:26 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, "Richard W.M. Jones" <rjones@redhat.com>,
        linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Message-ID: <20160517122326.GJ511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160516121456.GA16970@redhat.com>
 <20160517093307.GG511@twin.jikos.cz>
 <c7d51f53-d3f9-d95f-cb4d-c320ced4ca9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c7d51f53-d3f9-d95f-cb4d-c320ced4ca9b@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 07:14:12AM -0400, Austin S. Hemmelgarn wrote:
> >> By this example I don't mean that JSON has to be the format -- in fact
> >> it's a terrible format with all sorts of problems -- any format which
> >> is parseable with C libraries would do for us.
> >
> > My ideas was to allow multiple formats, with slight change to the
> > syntax:
> >
> > $ btrfs --format=json ...
> > $ btrfs --format=plain ...
> > $ btrfs --format=yaml ...
> I like this idea, with one specific caveat, it would be _really_ nice to 
> be able to control at compile time what formats are supported. 
> Somebody's eventually going to want XML support, and I'd rather not have 
> to depend on expat or something similar in a tool that I regularly build 
> statically (I'm willing to tolerate YAML because that's what I'd use, 
> but I would probably compile out the JSON support too).

I hope we can avoid any 3rd party library dependencies, we're just
generating the output not parsing it. Either copy a version of the
libraries or copy the quoting code, the rest can be simply implemented as
a printf with enhanced format stings.
