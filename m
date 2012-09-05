Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55597 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2IEPE1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 11:04:27 -0400
Date: Wed, 5 Sep 2012 17:04:02 +0200
From: David Sterba <dave@jikos.cz>
To: Shentino <shentino@gmail.com>
Cc: dave@jikos.cz, Michael <mike@draftx.net>, cwillu <cwillu@cwillu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: rfc: fuzz testing by direct writes to device
Message-ID: <20120905150402.GK17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
 <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
 <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
 <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
 <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
 <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
 <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com>
 <20120902054410.GG17430@twin.jikos.cz>
 <CAGDaZ_r1zZWGh5riLnNnZR8raZZQNwSe0qSNgY3BaBWN-A9Fbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGDaZ_r1zZWGh5riLnNnZR8raZZQNwSe0qSNgY3BaBWN-A9Fbg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 02, 2012 at 04:43:48AM -0700, Shentino wrote:
> I assume the same results are expected during a scrub as during a normal read?

yes

> > I've tested this on an 2 disk data/raid1, metadata/raid1 with a running
> > dd over one of the devices continually and using the filesystem. It was
> > slower.
>
> Would I be correct to assume that a core dump on fsck is an automatic
> bug or is using the old 3.3.8 kernel a taint that would invalidate a
> report?  Note that this is for the btrfs-progs containing the fsck,
> not the actual kernel side code.

You're talking about fsck and kernel, I'm not quite sure which one do
you refer to with 'bug'.

fsck can crash when it finds unexpected data in the tree structures,
but this would mean that it passed through the checksum verification
earlier. This would be a bug, and if it is reproducible on newer kernels
a report on 3.3.x does not disqualify it right away.

Same holds for kernel, a datastructure inconsistency will most probably
lead to a BUG and subsequent crash.

david
