Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45293 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2JIJAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 05:00:22 -0400
Date: Tue, 9 Oct 2012 11:00:12 +0200
From: David Sterba <dave@jikos.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009090012.GJ4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009073357.GB13692@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121009073357.GB13692@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 08:33:57AM +0100, Richard W.M. Jones wrote:
> On Tue, Oct 09, 2012 at 08:20:02AM +0100, Richard W.M. Jones wrote:
> > On Mon, Oct 08, 2012 at 08:00:51PM -0400, Chris Mason wrote:
> > > Ok, what's a rough idea of the mainline git equiv of the buggy kernel?
> > 
> > On my local machine, I'm reproducing this with what Fedora calls
> > 3.7.0-0.rc0.git2.4.fc19.x86_64
> 
> OK, that's not very helpful is it :-)  AFAIK it should be possible
> to reproduce this with Linus's git kernel, but I haven't proven
> that yet.

Found the same error message in my logs with master+next:

Oct  8 15:07:25 kernel: [13048.856283] device fsid cd15a893-e955-49cc-989c-4fd952a838a6 devid 1 transid 3 /dev/sda9
Oct  8 15:07:25 kernel: [13048.866880] btrfs: disk space caching is enabled
Oct  8 15:07:25 kernel: [13048.875767] btrfs: failed to recover relocation
Oct  8 15:07:25 kernel: [13048.884662] btrfs: open_ctree failed

There are some xfstests that triggered the related bug with stale data,
I'm investigating further.


david
