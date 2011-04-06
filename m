From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: don't kzalloc the ordered extents
Date: Wed, 06 Apr 2011 07:06:16 -0400
Message-ID: <1302087945-sup-6943@think>
References: <1302045649-1580-1-git-send-email-josef@redhat.com> <4D9C1C1F.8090208@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D9C1C1F.8090208@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-04-06 03:54:07 -0400:
> On 06.04.2011 01:20, Josef Bacik wrote:
> > We initialize almost all of the fields when we allocate an ordered extent, so
> > use kmalloc instead of kzalloc and just initialize the other fields that we
> > don't already initialize yet.  Thanks,
> 
> Is it really worth it? we have seen a few bugs in the past resulting
> from uninitialized structure element, that even made it to disk.
> Using kzalloc makes maintenance much easier.

I'm a big kzalloc fan unless this particular caller shows up in
benchmarks.  Josef how much did this one help?

-chris
