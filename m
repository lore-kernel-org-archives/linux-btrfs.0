Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57787 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751064AbaJJB65 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 21:58:57 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: What is the vision for btrfs fs repair?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54358C77.2070808@redhat.com>
Date: Thu, 9 Oct 2014 21:58:53 -0400
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
References: <54358C77.2070808@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 8, 2014, at 3:11 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> I was looking at Marc's post:
> 
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
> 
> and it feels like there isn't exactly a cohesive, overarching vision for
> repair of a corrupted btrfs filesystem.

It's definitely confusing compared to any other filesystem I've used on four different platforms. And that's when excluding scraping and the functions unique to any multiple device volume: scrubs, degraded mount.

To be fair, mdadm doesn't even have a scrub command, it's done via 'echo check > /sys/block/mdX/md/sync_action'. And meanwhile LVM has pvck, vgck, and for scrubs it's lvchange --syncaction {check|repair}. These are also completely non-obvious.

> * mount -o recovery
> 	"Enable autorecovery attempts if a bad tree root is found at mount time."

I'm confused why it's not the default yet. Maybe it's continuing to evolve at a pace that suggests something could sneak in that makes things worse? It is almost an oxymoron in that I'm manually enabling an autorecovery

 If true, maybe the closest indication we'd get of btrfs stablity is the default enabling of autorecovery.

> * btrfs-zero-log
> 	"remove the log tree if log tree is corrupt"
> * btrfs rescue
> 	"Recover a damaged btrfs filesystem"
> 	chunk-recover
> 	super-recover
> 	How does this relate to btrfs check?
> * btrfs check
> 	"repair a btrfs filesystem"
> 	--repair
> 	--init-csum-tree
> 	--init-extent-tree
> 	How does this relate to btrfs rescue?

These three translate into eight combinations of repairs, adding -o recovery there are 9 combinations. I think this is the main source of confusion, there are just too many options, but also it's completely non-obvious which one to use in which situation.

My expectation is that eventually these get consolidated into just check and check --repair. As the repair code matures, it'd go into kernel autorecovery code. That's a guess on my part, but it's consistent with design goals.


> It feels like recovery tools have been badly splintered, and if there's an
> overarching design or vision for btrfs fs repair, I can't tell what it is.
> Can anyone help me?

I suspect it's unintended splintering, and is an artifact that will go away. I'd rather the convoluted, fractured nature of repair go away before the scary experimental warnings do.


Chris Murphy