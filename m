Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbcCURto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:49:44 -0400
Date: Mon, 21 Mar 2016 18:49:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Fuhry <dan@fuhry.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Add support for RENAME_{EXCHANGE,WHITEOUT}
Message-ID: <20160321174914.GC8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAO8L9g6EpXMNjWVunz2A-EPwGHBo=18T_a+3xovqMbHux3aHsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO8L9g6EpXMNjWVunz2A-EPwGHBo=18T_a+3xovqMbHux3aHsw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 10:52:28AM -0500, Dan Fuhry wrote:
> Add support for the RENAME_WHITEOUT and RENAME_EXCHANGE flags in
> renameat2(). This brings us pretty close to having btrfs ready to be
> an upper layer for overlayfs. (The last remaining issue is in
> btrfs_sync_file, which I'm looking at next if I have time.)

The sync_file issue should be fixed by filipes' fix from today.

> This includes Davide Italiano's implementation of RENAME_EXCHANGE. I
> quickly pinged him on github [1] last week to confirm resubmission of
> his patch which originally went to this list on 2 April 2015 and
> didn't make it in.
> 
> This is my first time submitting a kernel patch, I think I've covered
> all the style recommendations, and also addressed Filipe David
> Manana's review notes [2] on Davide Italiano's patch. Certainly let me
> know if there's anything else that should be cleaned up. Thanks!

The patch style looks, I've briefly tested it in fstests and it blows
very quickly, the stacktraces are unreadable. So I could mismerge it or
there's another reason. Anyway, I'm going to pick this patch for 4.7 and
will add it to my for-next after the crashes are resolved.
