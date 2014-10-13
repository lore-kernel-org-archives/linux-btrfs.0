Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3385 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbaJMVJp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 17:09:45 -0400
Message-ID: <543C3F93.8080403@fb.com>
Date: Mon, 13 Oct 2014 17:09:39 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com>
In-Reply-To: <54358C77.2070808@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/08/2014 03:11 PM, Eric Sandeen wrote:
> I was looking at Marc's post:
>
> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=XJPoqgf9jjvuE1IqCerEXXuwF4w3hbDS3%2F63x5KI4R4%3D%0A&s=b1f817d758eacf914bd60f20ada715384e13c1f8e040100794b0cb21261ec884
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
> What's the vision for, say, scrub vs. check vs. rescue?  Should they repair the
> same errors, only online vs. offline?  If not, what class of errors does one fix vs.
> the other?  How would an admin know?  Can btrfs check recover a bad tree root
> in the same way that mount -o recovery does?  How would I know if I should use
> --init-*-tree, or chunk-recover, and what are the ramifications of using
> these options?
>
> It feels like recovery tools have been badly splintered, and if there's an
> overarching design or vision for btrfs fs repair, I can't tell what it is.
> Can anyone help me?
>

We probably should just consolidate under 3 commands, one for online 
checking, one for offline repair and one for pulling stuff off of the 
disk when things go to hell.  A lot of these tools were born out of the 
fact that we didn't have a fsck tool for a long time so there were these 
stop gaps put into place, so now its time to go back and clean it up.

I'll try and do this after I finish my cleanup/sync between kernel and 
progs work and fill out the documentation a little better so its clear 
when to use what.  Thanks,

Josef

