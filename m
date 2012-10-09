Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45646 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab2JIJRE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 05:17:04 -0400
Date: Tue, 9 Oct 2012 11:16:57 +0200
From: David Sterba <dave@jikos.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009091657.GK4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121009072002.GJ24071@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 08:20:02AM +0100, Richard W.M. Jones wrote:
> On my local machine, I'm reproducing this with what Fedora calls
> 3.7.0-0.rc0.git2.4.fc19.x86_64 (note I found an unrelated but very
> serious bug in this kernel:
> http://marc.info/?l=linux-kernel&m=134973394826408&w=2 )

And it's going to be fixed

http://marc.info/?l=linux-fsdevel&m=134973493227376&w=2

david
