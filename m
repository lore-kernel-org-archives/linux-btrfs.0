From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Wed, 8 Feb 2012 15:01:09 -0600
Message-ID: <CAKcLGm-ps-B9jZ8Xyxy0BduDcgzEtwsy0FzFhmV1GWZ_MP8q2g@mail.gmail.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2012 at 10:13 AM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I have a Btrfs partition that is reliably reproducing premature ENOSPC
> when restoring the disk from a tar file, but it is only happening with
> zlib compression (lzo or no compression proceeds normally).
>
> I've had the same issue at least back through the 3.1 kernel series,
> and I've been having intermittent issues even further back.
>
> I am currently using a 3.2.1 kernel merged with Chris' latest
> integration branch.
>
> I've performed about 12 trials trying to explore various combinations
> of compress, compress-force, compress[-force]=[zlib,lzo] and
> autodefrag.
>
> If I use no compression, or if I explicitly declare lzo compression, I
> don't receive the premature ENOSPC when untarring my restoration
> archive to the empty partition.
>
> If I don't specify compression (zlib is the default) or specify zlib,
> I get consistent premature ENOSPC errors regardless of other
> combinations.
>
> I apologize if this is already general knowledge, but I couldn't see
> where this has been posted to the list before.
>
> As time allows, I will try to capture exactly where this ENOSPC is
> being issued in btrfs by inserting WARN_ON's in my local version
> where-ever ENOSPC is set.

Some follow-up...

I've injected some debugging code to isolate when the ENOSPC is being
generated when using zlib compression.

When using zlib, I'm getting intermittent ENOSPC in the
may_commit_transaction() function in extent-tree.c at this point:

	if (delayed_rsv->size < bytes) {
		spin_unlock(&delayed_rsv->lock);
		return -ENOSPC;
	}

The typical values for (delayed_rsv->size < bytes) have been:
delayed_rsv->size ( = 0x60000) < bytes ( = 0x78000)

This typically occurs when unzipping a section of my backup that
contains lots of small files that are probably being mostly in-lined.

I don't see errors in this section when using lzo or no compression.
