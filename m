Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbAJKRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 05:17:07 -0500
Date: Sat, 10 Jan 2015 02:17:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150110101703.GA5385@infradead.org>
References: <20150105172152.GB19126@gardel-login>
 <20150107135734.GA21327@gardel-login>
 <20150107144250.GA2901@infradead.org>
 <8849914.dEW4UQEyXo@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8849914.dEW4UQEyXo@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 10, 2015 at 11:13:52AM +0100, Martin Steigerwald wrote:
> What is the issue with the xstat, new stat format stuff? Basically I have the 
> feeling that this is in discussion for at least 5 years or so and I always 
> wondered where it is stuck. I am not aware of any discussions of it recently, 
> but I may have overseen those.

It's mostly because it turned on into an exercise of blatant
overengineering.  The primary need in the stat area is a few new fields,
and the secondary interesting one is to allow the user to request only
some field that it actually needs (i.e. statlite).  But all the
proposals included bullshit like variable length fields, xattrs and
similar and thus were totally off the table.
