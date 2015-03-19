Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbbCSN0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 09:26:33 -0400
Date: Thu, 19 Mar 2015 14:26:31 +0100
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Zolt=E1n?= Halassy <cf0hay@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs filesystem resize synchronous?
Message-ID: <20150319132631.GF20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAC-qVGA-F=8pNcp+zRvQqd5=ag67Ykb2BVYLzLb1Wtp7zqYW0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAC-qVGA-F=8pNcp+zRvQqd5=ag67Ykb2BVYLzLb1Wtp7zqYW0Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 04:36:17PM +0100, Zoltán Halassy wrote:
> Is it safe to use do something like this:
> 
> # btrfs filesystem resize 100m /mnt/something && lvreduce -f -L100M
> /dev/somevg/somelv
> 
> as in, when the first command exits with 0 status, is the filesystem
> already resized? I mean, it's 100% sure the FS driver will not touch
> any blocks beyond the requested size after the resize successfully
> returned?

Yes.

> I guess the utility just signals some ioctl to the mounted
> filesystem, but I wonder if the ioctl only returns successfully when
> it finished the task.

Yes, the ioctl starts a transaction and waits until it's committed, so
the new filesystem size is permanent at the time the ioctl returns.

> Sorry if this is a noise, I didn't find anything about this in the
> user documentation, and it is not obvious for me. I read somewhere,
> the FS driver does not check for missing blocks at the end of the
> device during mount (eg, when the device is smaller than the reported
> size in the superblock), and will simply throw io errors when tries to
> access those blocks. This made me ask the question above.

That's a bit different question.  If the block device is smaller than
the filesystem expects, then the out of bounds read attempts happen,
though this could/should be checked at the mount time.
