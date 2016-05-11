Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcEKRhW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 13:37:22 -0400
Date: Wed, 11 May 2016 19:36:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160511173659.GI29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160511025211.GF7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 07:52:11PM -0700, Mark Fasheh wrote:
> Taking your history with qgroups out of this btw, my opinion does not
> change.
> 
> With respect to in-memory only dedupe, it is my honest opinion that such a
> limited feature is not worth the extra maintenance work. In particular
> there's about 800 lines of code in the userspace patches which I'm sure
> you'd want merged, because how could we test this then?

I like the in-memory dedup backend. It's lightweight, only a heuristic,
does not need any IO or persistent storage. OTOH I consider it a subpart
of the in-band deduplication that does all the persistency etc. So I
treat the ioctl interface from a broader aspect.

A usecase I find interesting is to keep the in-memory dedup cache and
then flush it to disk on demand, compared to automatically synced dedup
(eg. at commit time).

> A couple examples sore points in my review so far:
> 
> - Internally you're using a mutex (instead of a spinlock) to lock out queries
>  to the in-memory hash, which I can see becoming a performance problem in the
>  write path.
> 
> - Also, we're doing SHA256 in the write path which I expect will
>  slow it down even more dramatically. Given that all the work done gets
>  thrown out every time we fill the hash (or remount), I just don't see much
>  benefit to the user with this.

I had some ideas to use faster hashes and do sha256 when it's going to
be stored on disk, but there were some concerns. The objection against
speed and performance hit at write time is valid. But we'll need to
verify that in real performance tests, which haven't happend yet up to
my knowledge.

> Users can get better dedupe via the ioctl today than with what
> you propose go in as an experimental feature so I don't see many people
> caring to test it. IMHO you would have to provide a more compelling reason
> to include this code.

I see it as a complementary feature in the deduplication capabilities,
covering more usecases.
