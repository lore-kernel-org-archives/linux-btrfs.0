Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbCYBtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 21:49:07 -0400
Date: Wed, 25 Mar 2015 02:49:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Petr Bena <benapetr@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New tool to recursive compress / decompress of files
Message-ID: <20150325014906.GD20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
 <20150321180846.GE31762@carfax.org.uk>
 <CA+4EQ5cWV-HaKGnmsn73Bif-w4otyz8JD_LRHeO=-Que+cRaYg@mail.gmail.com>
 <CA+4EQ5chrXyaoLs09TdK09npfCxvLKDTZor5Bqc9wqqX3xpKkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+4EQ5chrXyaoLs09TdK09npfCxvLKDTZor5Bqc9wqqX3xpKkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 21, 2015 at 07:16:47PM +0100, Petr Bena wrote:
> I am just wondering, does that defragment trick work for non-root users?

Defragmentation works where read and write would work for the user. Root
can also defrag files that do not have the wite rwx bit set, but it's a
special case anyway.

> Also, even if it did work, I could as well make my tools use this
> defragment trick instead, because I will probably never remember that
> hacky syntax of defrag command :P doing something like compress -r
> <folder> or decompress -r <folder> is just much more easy to remember
> than multiple commands.

The tools should provide a rich set of options to do basic operations
and could provide options to do complex things, but writing wrappers is
sometimes inevitable.

In your case, we can enhance the defrag command to set the +c bit on
directories/files on the way, plus set the compression method via
properties according to the user selected method. All of this fits into
the idea of core tool support.
