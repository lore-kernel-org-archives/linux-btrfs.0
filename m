Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754260AbdIHQlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 12:41:08 -0400
Date: Fri, 8 Sep 2017 18:39:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908163939.GS31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908153816.GD23980@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 03:38:16PM +0000, Hugo Mills wrote:
> > sometimes I'm really thinking about start rewrite btrfs-progs to make
> > btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
> > zpool and zdb commands on using which in +90% cases you can guess how
> > necessary syntax must look like without looking on man pages.
> > 
> > Any volunteers want to join to help implement something like this?
> > Maybe someone already started doing this?
> 
>    The main complaint that can be directed at the btrfs command is
> that its output is rarely machine-processable. It would therefore make
> sense to have a "--table" or "--structured" mode for output, which
> would be more trivially parsable by shell tools.

My plan is to introduce a global options to set various this, also the
output format, eg.

 $ btrfs --format=json subvolume list

that would dump the list in json obviously, more formats could follow.
This requires to switch all printf to a wrapper that would select the
format based on global config. Some of the code is there, eg. the global
option parser and the config structure. The printf transitions can be
done incrementally. All of that is easy IMHO, somebody just needs to do
it. I work on that when there are no other more pressing things to do.
