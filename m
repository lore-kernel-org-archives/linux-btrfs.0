From: David Sterba <dave@jikos.cz>
Subject: Re: BUG: scheduling while atomic: mount/1608/0x00000002
Date: Tue, 14 Jun 2011 02:52:46 +0200
Message-ID: <20110614005246.GX12709@twin.jikos.cz>
References: <20110613180821.GA8196@gmail.com>
 <20110613232100.GW12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: dont <dontbeeeevil@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110613232100.GW12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2011 at 01:21:00AM +0200, David Sterba wrote:
> The code 1972-1979 was added by cleancache. I've asked the reporter to
> try it without cleancache, but we did not figure out how to disable it
> on commandline (and there was no followup on compiling without
> cleancache).

without cleancache compiled in, same stacktraces.
