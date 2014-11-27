Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:51911 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaK0AUY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:20:24 -0500
Date: Thu, 27 Nov 2014 05:20:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Message-ID: <20141127052021.47734be0@natsu>
In-Reply-To: <54766997.1040101@pobox.com>
References: <20141127005527.42a7fe59@natsu>
 <54765FC2.2050309@pobox.com>
 <20141127043337.198d6084@natsu>
 <54766997.1040101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 26 Nov 2014 16:00:23 -0800
Robert White <rwhite@pobox.com> wrote:

> Uh... you may _still_ have no checksums on any of those data extents. 
> They are not going to come back until you write them to a normal file 
> with a normal copy. So you may be lacking most of the data validation 
> features of this filesystem.

Well, this FS is coming from being Ext4 for years, so it's not worse off now
than it was before. And anyways the main feature that I wanted were snapshots.

> You might want to go experiment. Make another new subvol (or at least a 
> directory in a directory/root/subvol that never had the +C attribute 
> set) and see if you can cp --reflink any of these files into that 
> subdirectory without repeating the +C trick.

Ha, indeed I can't. Maybe there should be a way to generate checksums without
rewriting files, just via reading them, then calculating and writing checksum
to metadata.

> Clearing NODATACOW does _not_ clear NODATASUM (at least not on a 
> non-empty file) as near as I can tell, so that directory hierarchy and 
> its subsequent snapshots is likely "less safe" than you think.

The nodatasum flag also isn't accessible via chattr, is it?

-- 
With respect,
Roman
