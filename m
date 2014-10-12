Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38457 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaJLKRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 06:17:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
Date: Sun, 12 Oct 2014 12:17:53 +0200
Message-ID: <2905860.B2VjmEPlfG@merkaba>
In-Reply-To: <54358C77.2070808@redhat.com>
References: <54358C77.2070808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 8. Oktober 2014, 14:11:51 schrieb Eric Sandeen:
> I was looking at Marc's post:
> 
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-> and-Btrfs-Filesystem-Repair.html
> 
> and it feels like there isn't exactly a cohesive, overarching vision for
> repair of a corrupted btrfs filesystem.
> 
> In other words - I'm an admin cruising along, when the kernel throws some
> fs corruption error, or for whatever reason btrfs fails to mount.
> What should I do?
> 
> Marc lays out several steps, but to me this highlights that there seem to
> be a lot of disjoint mechanisms out there to deal with these problems;
> mostly from Marc's blog, with some bits of my own:
> 
> * btrfs scrub
> 	"Errors are corrected along if possible" (what *is* possible?)
> * mount -o recovery
> 	"Enable autorecovery attempts if a bad tree root is found at mount time."
> * mount -o degraded
> 	"Allow mounts to continue with missing devices."
> 	(This isn't really a way to recover from corruption, right?)
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
> * btrfs restore
> 	"try to salvage files from a damaged filesystem"
> 	(not really repair, it's disk-scraping)
> 
> 
> What's the vision for, say, scrub vs. check vs. rescue?  Should they repair
> the same errors, only online vs. offline?  If not, what class of errors
> does one fix vs. the other?  How would an admin know?  Can btrfs check
> recover a bad tree root in the same way that mount -o recovery does?  How
> would I know if I should use --init-*-tree, or chunk-recover, and what are
> the ramifications of using these options?
> 
> It feels like recovery tools have been badly splintered, and if there's an
> overarching design or vision for btrfs fs repair, I can't tell what it is.
> Can anyone help me?

How about taking one step back:

What are the possible corruption cases these tools are meant to address? 
*Where* can BTRFS break and *why*?

What of it can be folded into one command? Where can BTRFS be improved to 
either prevent a corruption from happening ot automatically correcting it? 
What actions can be determined automatically by the repair tool? What needs to 
be options for the user to choose from? And what guidance would the user need 
to decide?

I.e. really going to back what diagnosing and repair of BTRFS actually 
includes and then well… go about a vision how this all can fit together as you 
suggested.

As a minimum I suggest to have all possible options as a main category in 
btrfs command, no external commands whatsoever, so if btrfs-zero-log is still 
needed, at it into btrfs command.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
