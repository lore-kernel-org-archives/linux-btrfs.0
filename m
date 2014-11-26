Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:51902 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaKZXdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 18:33:40 -0500
Date: Thu, 27 Nov 2014 04:33:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Message-ID: <20141127043337.198d6084@natsu>
In-Reply-To: <54765FC2.2050309@pobox.com>
References: <20141127005527.42a7fe59@natsu>
	<54765FC2.2050309@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 26 Nov 2014 15:18:26 -0800
Robert White <rwhite@pobox.com> wrote:

> So you _could_ reflink the file but you'd have to do it to another file 
> with no data checksums -- which basically means a NOCOW file, or 
> mounting with nodatasum while you do the reflink, but now you have more 
> problem files.

Bingo!!! A cp --reflink to a destination that's been made chattr +C prior to
that, works perfectly.

My goal was to convert regular top-level directories into subvolumes (for
further snapshotting). With that trick, I've been able to do that now w/o
issues.

$ mv Music Music.orig
$ sudo btrfs sub create Music
Create subvolume './Music'
$ sudo chattr +C Music
$ sudo cp -a --reflink Music.orig/* Music/
$ 

Finished with no rewriting necessary. After that I recursively-removed the +C
attribute from all newly reflinked files, and cp --reflink as well as
snapshotting of those works fine.

Thanks for the idea. :)

-- 
With respect,
Roman
