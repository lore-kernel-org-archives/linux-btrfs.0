From: Sage Weil <sage@newdream.net>
Subject: Re: [Fwd: Re: Linking two files together][RFC]
Date: Wed, 9 Jun 2010 12:17:48 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1006091215100.17968@cobra.newdream.net>
References: <4C0F809C.4040209@robertoragusa.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Roberto Ragusa <mail@robertoragusa.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C0F809C.4040209@robertoragusa.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 9 Jun 2010, Roberto Ragusa wrote:
> I hope that ideas about btrfs are not off-topic for this mailing list.
> 
> The forwarded message below was written by me on fedora-users.
> The thread is about the ability to link two files in a manner
> similar to "cat 1 2 >3 && rm 1 2" while avoiding any data
> movement on the disk.
> The implementation should just put the original extents together in
> the new file. Is there any filesystem which is capable of doing that?
> As btrfs is already based on extents and COW, couldn't this feature be
> evaluated for feasibility? I think a lot of usages will be found
> for it if actually implemented.

Btrfs already has a CLONE_RANGE ioctl that will clone a range of 
(block-aligned) bytes from file A to any offset in file B.  The fs just 
fixes up the file metadata to reference the same bytes on disk without 
reading or writing any actual file data.

sage
