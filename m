Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50711 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbeFYNjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 09:39:04 -0400
Date: Mon, 25 Jun 2018 15:36:12 +0200
From: David Sterba <dsterba@suse.cz>
To: waxhead <waxhead@dirtcellar.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unsolvable technical issues?
Message-ID: <20180625133611.GC27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 01:13:31AM +0200, waxhead wrote:
> According to this:
> 
> https://stratis-storage.github.io/StratisSoftwareDesign.pdf
> Page 4 , section 1.2
> 
> It claims that BTRFS still have significant technical issues that may 
> never be resolved.
> Could someone shed some light on exactly what these technical issues 
> might be?! What are BTRFS biggest technical problems?

The subject you write is 'unsolvable', which I read as 'impossible to
solve', eg. on the design level. I'm not aware of such issues.

If this is about issues that are difficult either to implement or
getting right, there are a few known ones.

> If you forget about the "RAID"5/6 like features then the only annoyances 
> that I have with BTRFS so far is...
> 
> 1. Lack of per subvolume "RAID" levels
> 2. Lack of not using the deviceid to re-discover and re-add dropped devices
> 
> And that's about it really...

This could quickly turn into 'my faviourite bug/feature' list that can
be very long. The most asked for are raid56, and performance of qgroups.

Qu Wenruo improved some of the core problems and Jeff is working on the
performance problem. So there are people working on that.

On the raid56 front, there were some recent updates that fixed some
bugs, but the fix for write hole is still missing so we can't raise the
status yet.  I have some some good news but nobody should get too
excited until the code lands.

I have prototype for the N-copy raid (where N is 3 or 4).  This will
provide the underlying infrastructure for the raid5/6 logging mechanism,
the rest can be taken from Liu Bo's patchset sent some time ago.  In the
end the N-copy can be used for data and metadata too, independently and
flexibly switched via the balance filters. This will cost one
incompatibility bit.
