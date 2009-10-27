From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: Oops and somewhat borked filesystem after btrfs-convert and image  removal
Date: Tue, 27 Oct 2009 10:12:49 +0200
Message-ID: <87bpjt6yri.fsf@kiiro.naked.iki.fi>
References: <87k4yi6kh9.fsf@kiiro.naked.iki.fi>
	<3d0408630910261923l70810a4bm99c719919c7cc99e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan\, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630910261923l70810a4bm99c719919c7cc99e@mail.gmail.com> (Zheng Yan's message of "Tue\, 27 Oct 2009 10\:23\:18 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

"Yan, Zheng " <yanzheng@21cn.com> writes:
> This is a known bug in btrfs kernel driver, it's fixed in 2.6.32-rcX.

Thank you, good to know.

> This is a known bug in btrfs-progs 0.19, it's fixed in
> btrfs-progs-untable tree.

Thank you, good to know.

> These errors are not critical. Some inodes' link counts are zero,
> but they aren't marked as orphan inodes. I have no idea how this
> can happen. Did you run btrfsck on mounted FS?

Yes, I did run it on a mounted FS. An earlier wiki document said that
btrfsck can be run on a mounted or an unmounted filesystem - however the
wiki said earlier that it can be run either on a mounted or an unmounted
fs. Btrfsck doesn't complain that it's being run on a mounted fs... then
again, I'm not sure if it can know that.

> Copying files out and in is the simplest and safest solution.
> Sorry for the inconvenience.

No problem.

But, I am wondering, is btrfsck at some point supposed to fix this kind
of corruption? Is it on the roadmap at some point?

I mean, it's ofcourse obvious that bugs like this are fixed at the
source, so errors like this should no longer happen. However, there will
always be bugs, or if not bugs then just the processor randomly
calculating wrong once in a blue moon, and it would be good to know that
btrfsck can fix the filesystem even in situations that "cannot"
happen. And free space accounting is probably easiest of them all.

-- Naked
