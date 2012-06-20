Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:36803 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783Ab2FTPiJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 11:38:09 -0400
Message-ID: <4FE1EE52.20002@zytor.com>
Date: Wed, 20 Jun 2012 08:37:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
CC: cwillu <cwillu@cwillu.com>, helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost>
In-Reply-To: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 05:02 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
> If I swap (via a rename) __active and __rollback, in the next boot my system
> uses a "good" copy of the root filesystem. This is a simple way to swap 
> two subvolumes, without involving the boot logic
> 
> Instead if I had tracked the subvolume-id, to swap the root filesystem I 
> would have update the boot logic.
> 
> I suspect that could exists other cases where it is preferable to track the 
> subvolume-id instead the path. However what I would highlight it is the two
> ways aren't equal.
> 

Yes.  The question here is what makes sense for the low-level part of a
bootloader (Syslinux in this case) to use, and it sounds like you have
some experience here that would be highly useful to have.

The thing to keep in mind here is that the low level bootloader code
*must* match what is installed in the boot block (functionally another
part of the bootloader), or all hell will break loose.  I think that
means that relying on the subvolume ID makes more sense.  To upgrade the
bootloader, invoke the bootloader installer at the end of the update;
that will repoint *everything*, which is rather nice.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

