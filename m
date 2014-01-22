Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbaAVMY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:24:57 -0500
Date: Wed, 22 Jan 2014 13:24:56 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Sandy McArthur <sandymac@gmail.com>,
        Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140122122456.GH6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <52DD148E.3060200@gmail.com>
 <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
 <52DE6747.4050404@gmail.com>
 <20140121165200.GF3314@carfax.org.uk>
 <20140122122010.GG6498@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140122122010.GG6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 22, 2014 at 01:20:10PM +0100, David Sterba wrote:
> I haven't done any extensive testing, only streaming writes, and the
> heuristic just batched writes by a given threshold before switching to
> another mirror.  Load balancing was done without any logic that would
> look at actual IO load of the devices. For me, the result was that
> there's room for improvement.

http://www.spinics.net/lists/linux-btrfs/msg12745.html
http://www.spinics.net/lists/linux-btrfs/msg17228.html
