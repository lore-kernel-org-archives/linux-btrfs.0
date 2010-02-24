From: Boyd Waters <waters.boyd@gmail.com>
Subject: Re: No space left on device, btrfsctl segmentation fault
Date: Wed, 24 Feb 2010 14:20:43 -0500
Message-ID: <2b0225fb1002241120y34f9f934na9d43a4fcfda2ac3@mail.gmail.com>
References: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
	 <20100224154353.GB2257@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100224154353.GB2257@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the suggestions, everyone!

I copied the data from the 2TB btrfs disk to an identical disk (same
make and model) formatted with ext4:

/dev/sdi2             1.9T  1.7T  197G  90% /media/onlyhope
/dev/sdg1             1.8T  1.7T   71G  96% /mnt/newhope

The metadata "overhead" for btrfs is a bit more, but it isn't outrageous IMHO.

==

Re-balancing the tree with "btrfs-vol -b" sounds about right, both in
terms of time and stability. I haven't tried that yet, but I can
report on that experiment.

Leszek wrote:
> The 'used' output of df on a btrfs system does not take metadata into
account. So the disk is really full. This is what my yesterdays path
is intended to fix - can you try it out?
>

I would like to try this patch, I apologize for being so new to btrfs
development: can you tell me where to find the patch? Is it for btrfs
tools or the btrfs itself? I will try to find it, but a quick pointer
to it will help me test!

Thanks again!
