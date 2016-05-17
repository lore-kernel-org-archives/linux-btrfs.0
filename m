Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbcEQJdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:33:35 -0400
Date: Tue, 17 May 2016 11:33:08 +0200
From: David Sterba <dsterba@suse.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Message-ID: <20160517093307.GG511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160516121456.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160516121456.GA16970@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 01:14:56PM +0100, Richard W.M. Jones wrote:
> I don't have time to implement this right now, so I'm just posting
> this as a suggestion/request ...

Neither do have I, but agree with the idea and the proposed way. Here
are my notes
https://github.com/kdave/drafts/blob/master/btrfs/progs-output-format.txt

> It would be really helpful if the btrfs tools had a machine-readable
> output.
> 
> Libguestfs parses btrfs tools output in a number of places, eg:
> https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c
> This is a massive PITA because each time a new release of btrfs-progs
> comes along it changes the output slightly, and we end up having
> to add all sorts of hacks.

The error messages haven't been touched for a long time and they get
fixed or rephrased incrementally. I'm sorry you have to deal with the
breakage but please understand that we don't have resources to do it at
once or to implement complete machine readable output. At the moment the
messages are aimed for a human consumer.

Wiring the various formats into the codebase would be pretty intrusive,
but doable. We can do some commands first as a prototype, the 'fi show'
seems like a good candidate.

> With machine-readable output, there'd be a flag which would
> change the output.  eg:
> 
> $ btrfs filesystem show
> Label: 'ROOT'  uuid: af471cfc-421a-4d51-8811-ce969f76828a
>         Total devices 1 FS bytes used 5.29MiB
>         devid    1 size 767.97MiB used 92.00MiB path /dev/sda2
> 
> would become:
> 
> $ btrfs --json filesystem show
> {
>   "devices": {
>      "Label": "ROOT",
>      "uuid": "af471cfc-421a-4d51-8811-ce969f76828a",
>      /// etc
>   }
> }
> 
> By this example I don't mean that JSON has to be the format -- in fact
> it's a terrible format with all sorts of problems -- any format which
> is parseable with C libraries would do for us.

My ideas was to allow multiple formats, with slight change to the
syntax:

$ btrfs --format=json ...
$ btrfs --format=plain ...
$ btrfs --format=yaml ...
