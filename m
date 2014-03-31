Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34401 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaCaUfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 16:35:40 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so4041868wiv.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 13:35:39 -0700 (PDT)
Subject: Re: [Help] Errors found in extent allocation tree or chunk allocation
Date: Mon, 31 Mar 2014 20:33:39 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20b782af1cb448c39cce358cd6d37e8c-mfwitten@gmail.com>
In-Reply-To: <pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
            <pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 31 Mar 2014 19:45:27 +0000 (UTC), Duncan wrote:

> Hopefully, none of those commands included btrfsck --repair

... Woops...

Fortunately, it doesn't seem to have changed anything.

> That goes double if you're running raid5/6 mode

For the record, I've essentially just put Btrfs on 1 block device
with no special RAID structuring (I suppose that would be, in
your parlance, `single mode').

For completeness, this is the actual structure:

  Raw disk 
    |
    +-> MSDOS partition
          |
          +-> LVM2 logical volume
                |
                +-> LUKS dm-crypt device
                      |
                      +-> Btrfs

I apologize if that ASCII art fails to render properly on your end.

> I'd actually put more faith in the btrfs balance command...
> Btrfs scrub is another alternative

I suppose, then, that my ultimate plan of action is thus:

  * Back up important data.

  * Give `btrfs scrub' a try.

  * Give `btrfs balance' a try.

  * Rebuild the file system if necessary.

> or if you're running a mixed-data/metadata chunk filesystem, the
> default for filesystems under a gig, which further defaults to
> dup mode if on a single device

Just as an aside, I find it odd that the default for such a small
system would be to duplicate user data.

--------

Thanks for your insights!
