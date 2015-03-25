Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbbCYBmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 21:42:03 -0400
Date: Wed, 25 Mar 2015 02:42:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Petr Bena <benapetr@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New tool to recursive compress / decompress of files
Message-ID: <20150325014200.GC20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
 <20150321180846.GE31762@carfax.org.uk>
 <CA+4EQ5cWV-HaKGnmsn73Bif-w4otyz8JD_LRHeO=-Que+cRaYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+4EQ5cWV-HaKGnmsn73Bif-w4otyz8JD_LRHeO=-Que+cRaYg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 21, 2015 at 07:12:52PM +0100, Petr Bena wrote:
> I would be certainly useful if this kind of tricks were mentioned on
> https://btrfs.wiki.kernel.org/index.php/Compression or anywhere on
> wiki

There's a gap between developers (who don't want to write documentation
because they know how to do things) and users (who expect there's enough
documentaion how to do things).

We're getting better and the user queries and complaints help to close
this gap but docs are still not perfect and somebody has to find the
time to write it.

The wiki is open, I'm merging documentation updates to btrfs-progs (ie.
man pages) right away, but this still does not seem to encourage enough
people. No coding skills rquired. Would github-style of pull requests
help to improve that? Or plain mails with the portions of text that'd
go to manpages (ie. no bothering with formatting)?
