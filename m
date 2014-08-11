Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:58573 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaHKSCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 14:02:53 -0400
Message-ID: <53E90409.5050105@jrs-s.net>
Date: Mon, 11 Aug 2014 13:57:29 -0400
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Ames Cornish <gmane@pub.cornishes.net>, linux-btrfs@vger.kernel.org
Subject: Re: Announcement: buttersink - like rsync for btrfs snapshots
References: <loom.20140811T193907-62@post.gmane.org>
In-Reply-To: <loom.20140811T193907-62@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How has it been for reliability?

I wrote a btrsync app a while back, and the app /itself/ worked fine, 
but the btrfs send / btrfs receive itself proved problematic.  Since 
btrfs would keep a partial receive - with no easy way to tell whether a 
receive WAS partial or full - I would inevitably end up with interrupted 
sends causing a problem that couldn't be resolved without manually 
deleting snapshots on the target end haphazardly until I nailed the 
incomplete one.

On 08/11/2014 01:49 PM, Ames Cornish wrote:
> I've written a utility to help me with using btrfs send and receive for
> backups or other synchronization, and I'd love to get feedback on it.
>
> As of this release, buttersink will synchronize a set of read-only snapshots
> in a btrfs filesystem to an Amazon S3 bucket, and vice-versa.  It
> intelligently picks parent snapshots to "diff" from, so that a minimal amount
> of data needs to be sent over the wire and stored in the backend.
>
> The utility is on PyPi as "buttersink", and the GitHub page is here:
>    https://github.com/AmesCornish/buttersink.
>
> Thanks in advance for any feedback!
>
> - Ames
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

