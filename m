Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34007 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933224AbdBHN0q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 08:26:46 -0500
Received: by mail-io0-f175.google.com with SMTP id l66so115629529ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 05:26:41 -0800 (PST)
Subject: Re: user_subvol_rm_allowed? Is there a
 user_subvol_create_deny|allowed?
To: Nicholas D Steeves <nsteeves@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170208014931.GA22397@DigitalMercury.dynalias.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7a6a1e4a-c68a-af78-58ce-c81d90ec4c06@gmail.com>
Date: Wed, 8 Feb 2017 07:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <20170208014931.GA22397@DigitalMercury.dynalias.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 20:49, Nicholas D Steeves wrote:
> Dear btrfs community,
>
> Please accept my apologies in advance if I missed something in recent
> btrfs development; my MUA tells me I'm ~1500 unread messages
> out-of-date. :/
>
> I recently read about "mount -t btrfs -o user_subvol_rm_allowed" while
> doing reading up on LXC handling of snapshots with the btrfs backend.
> Is this mount option per-subvolume, or per volume?
AFAIK, it's per-volume.
>
> Also, what mechanisms to restrict a user's ability to create an
> arbitrarily large number of snapshots?  Is there a
> user_subvol_create_deny|allowed?  What I've read about the inverse
> correlation between number of subvols to performance, a potentially
> hostile user could cause an IO denial of service or potentially even
> trigger an ENOSPC.
Currently, there is nothing that restricts this ability.  This is one of 
a handful of outstanding issues that I'd love to see fixed, but don't 
have the time, patience, or background to fix it myself.
>
> From what I gather, the following will reproduce the hypothetical
> issue related to my question:
>
> # as root
> btrfs sub create /some/dir/subvol
> chown some-user /some/dir/subvol
>
> # as some-user
> cd /home/dir/subvol
> cp -ar --reflink=always /some/big/files ./
> COUNT=1
> while [ 0 -lt 1 ]; do
>   btrfs sub snap ./ ./snapshot-$COUNT
>   COUNT=COUNT+1
>   sleep 2   # --maybe unnecessary
> done
>
fWIW, this will cause all kinds of other issues too.  It will however 
slow down exponentially over time as a result of these issues though. 
The two biggest are:
1. Performance for large directories is horrendous, and roughly 
exponentially (with a small exponent near 1) proportionate to the 
inverse of the number of directory entries.  Past a few thousand 
entries, directory operations (especially stat() and readdir()) start to 
take long enough for a normal person to notice the latency.
2. Overall filesystem performance with lots of snapshots is horrendous 
too, and this also scales exponentially proportionate to the inverse of 
the number of snapshots and the total amount of data in each.  This will 
start being an issue much sooner than 1, somewhere around 300-400 
snapshots most of the time.

