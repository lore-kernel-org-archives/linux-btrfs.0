Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:59804 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbaBPUoj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 15:44:39 -0500
Message-ID: <53012334.3070300@jrs-s.net>
Date: Sun, 16 Feb 2014 15:44:36 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: GEO <1g2e3o4@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS send: exclude directories
References: <11335246.MGjIN0NiaF@linuxpc>
In-Reply-To: <11335246.MGjIN0NiaF@linuxpc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplest way to do it is to make the directories that you don't want to 
replicate be separate subvolumes. I do this to keep from replicating 
copies of snapshot directories.

Example:

mv /home/GEO/.cache /home/GEO/.cache.tmp
btrfs sub create /home/GEO/.cache
cp -a --reflink=always /home/GEO/.cache.tmp/ /home/GEO/.cache/
cp -a --reflink=always /home/GEO/.cache.tmp/.* /home/GEO/.cache/
rm -rf /home/GEO/.cache.tmp

You could also just mv the files instead of first doing cp and then 
rm'ing them, but if you have many gigs of files, the cp --reflink=always 
will be a win - currently (at least, last I checked) mv across 
subvolumes would actually do a full copy, whereas a cp --reflink=always 
will just create new pointers to the blocks in the appropriate place 
(thereby completing instantaneously).

Anyway, once .cache (or whatever) is a subvolume instead of a directory, 
it will no longer get replicated with your btrfs send command of its 
parent directory.

On 02/16/2014 03:07 PM, GEO wrote:
> Hi,
>
> I have been experimenting with btrfs send/receive for incremental backups, but
> could not figure out how to exclude certain directories from
> subvolumes/snapshots. For example, I want to backup my data in home, but I am
> not interested in backing up hidden directories like .cache too.
> Is it currently possible to achieve something like that?
>
> Thanks for the great work!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

