Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbaLBN2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 08:28:43 -0500
Date: Tue, 2 Dec 2014 14:28:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
Message-ID: <20141202132842.GT12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 08:51:40AM +0530, Shriramana Sharma wrote:
> > openSUSE uses subvol id 5 for installing the OS to, and some
> > directories are made subvolumes such as home var and maybe usr.
> > Therefore when subvolid 5 is snapshot, those are exempt, and have to
> > be individually snapshot.
> 
> Yes I also noticed that openSUSE creates such separate subvols, but is
> there any particular benefit to making it so?

A subvolume is also a snapshotting barrier, so it's convenient to create
subvolumes in well-known paths that contain data that should not be
rolled back (/var/log, /srv, bootloader).
