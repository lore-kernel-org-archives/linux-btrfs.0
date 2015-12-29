Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbbL2RWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 12:22:11 -0500
Date: Tue, 29 Dec 2015 18:19:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: should btrfsck fix a bad superblock?
Message-ID: <20151229171956.GC4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtT78=kqXZVDAV-x0C1NW=7okBBM_+vM3+HAc5BtUArsiw@mail.gmail.com>
 <pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 02:28:19AM +0000, Duncan wrote:
> Btrfs check's -s option simply lets you use a different superblock.  I 
> don't believe check is designed to actually fix superblocks, tho I guess 
> with --repair it fixes certain bad fields in them.

The superblock is a special type of metadata, 'btrfs check' works on the
the trees pointed by it. There's the super-recover command you mentioned
and also the (still) standaone btrfs-select-super tool that are supposed
to fix the superblock itself.

Similarly, check may find specific problems, will not attempt to fix all
of them and could suggest to use a specialized fix tool. The reasons are
to avoid overbloating the checker command line options. An example is
the b-tree key bitflip fix (code not merged yet).
