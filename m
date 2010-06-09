From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Fwd: Re: Linking two files together][RFC]
Date: Wed, 09 Jun 2010 21:05:12 +0200
Message-ID: <87mxv43u3b.fsf@basil.nowhere.org>
References: <4C0F809C.4040209@robertoragusa.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Roberto Ragusa <mail@robertoragusa.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C0F809C.4040209@robertoragusa.it> (Roberto Ragusa's message of "Wed\, 09 Jun 2010 13\:53\:00 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Roberto Ragusa <mail@robertoragusa.it> writes:

> I hope that ideas about btrfs are not off-topic for this mailing list.
>
> The forwarded message below was written by me on fedora-users.
> The thread is about the ability to link two files in a manner
> similar to "cat 1 2 >3 && rm 1 2" while avoiding any data
> movement on the disk.

OCFS2 can do this today with "reflinks"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
