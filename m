Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:56391 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbaJXEHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 00:07:35 -0400
Message-ID: <5449D085.9030801@pobox.com>
Date: Thu, 23 Oct 2014 21:07:33 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Mounting(multiply)? Options(stored)? Options(barriers)?
References: <544980BA.8080007@pobox.com> <pan$ce81d$b98a312d$87b2f050$bb8a9bd1@cox.net>
In-Reply-To: <pan$ce81d$b98a312d$87b2f050$bb8a9bd1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2014 07:25 PM, Duncan wrote:
> See the discussion above.  As for whether conflicting options error out,
> get ignored, or update the whole filesystem, there has been some
> discussion on the list but IDR the conclusion as it doesn't pertain to me
> since I don't use subvolumes like that, preferring fully independent
> filesystems on their own partitions, instead.  (If the filesystem
> metadata gets corrupted, it can easily mean the loss of all data on it.
> Subvolumes provide little if any protection in that regard.  I *STRONGLY*
> prefer not to put all my data eggs in one filesystem basket, in case its
> bottom falls out.)  I believe in some cases either the conflicting mount
> will error out or it'll mount but ignore the conflicts (IOW, it shouldn't
> arbitrarily rewrite the option for the entire filesystem, that's what
> remount is for!), but don't know if it actually works that way for
> everything yet.  Either watch for a response from someone with practical
> knowledge of the situation, or do your own testing, before you depend on
> it.

Ouch, I abandoned multiple hard partitions on any one spindle a long, 
long time ago. The failure modes likely to occur just don't justify the 
restrictions and hassle. Let alone the competitive file-system 
scheduling that can eat your system performance with a box of wine.

I've been in this mess since Unix System 3 release 4. The mythology of 
the partitioned disk is deep and horrible. Ever since they stopped the 
implementation of pipes as anonymous files on the root partition, most 
of the reasoning ends up backward.

Soft failures are likely to spray the damage all over all the 
filesystems by type, and a disk failure isn't going to obey the 
partition boundaries.

Better the efficiency of the whole disk file-systems and a decent backup 
plan.

Just my opinion.
