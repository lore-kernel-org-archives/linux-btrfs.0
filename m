Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbcEQPFB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 11:05:01 -0400
Date: Tue, 17 May 2016 17:04:33 +0200
From: David Sterba <dsterba@suse.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Message-ID: <20160517150433.GU511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160516121456.GA16970@redhat.com>
 <20160517093307.GG511@twin.jikos.cz>
 <c7d51f53-d3f9-d95f-cb4d-c320ced4ca9b@gmail.com>
 <20160517122326.GJ511@twin.jikos.cz>
 <b9136e93-2099-245e-46a0-941d72279e1f@gmail.com>
 <20160517133214.GT1683@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160517133214.GT1683@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 02:32:14PM +0100, Richard W.M. Jones wrote:
> As I said I don't have any particular favourite format.  However I'll
> just point you to the code that qemu uses (basically open-coding) to
> write json:
> 
> http://git.qemu.org/?p=qemu.git;a=blob;f=qobject/qjson.c;h=ef160d2119eb18aa917b71b40e37d54880b1ac7f;hb=HEAD#l83
> 
> Hopefully this is useful as a data point.

It is, thanks, this amount of code to do json export matches my
expectations of a local version of the sources.
