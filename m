Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42144 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbaDNSsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 14:48:46 -0400
Message-ID: <534C2D95.4090103@fb.com>
Date: Mon, 14 Apr 2014 14:48:53 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Shaun Reich <sreich@kde.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: sub del: directory not empty, even though it is
References: <CADVynFCg4KWN9AGNKXAjoamwoLfNO4Q5czv+UCdEhqXWrG8P8A@mail.gmail.com>
In-Reply-To: <CADVynFCg4KWN9AGNKXAjoamwoLfNO4Q5czv+UCdEhqXWrG8P8A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/14/2014 12:50 PM, Shaun Reich wrote:
> attempting to restructure my fs snapshots the proper way, previous way
> was like this:
>
> (subvol=0)
> boot
> etc
> var
> ...
> SNAPSHOTS/01-16-14/{boot,etc,dev, proc..}
> SNAPSHOTS/03-22-14... etc
>
> i removed all but the 01-16-14 via sub del. i then thought 'i don't
> want the data at top-level anyways as its a botched upgrade, so i'll
> just revert to the last snapshot via a mv.
>
> so i rm'd everything at top level except snapshots, cd
> snapshots/01-16-14;mv * ../..
>
> now an ls -a at the dated dir shows empty, my files are where they
> should be so i really just want this to be gone. and a sub list on the
> top-level mount path lists:
>
> # btrfs sub list -ta /mnt/1
> ID      gen     top level       path
> --      ---     ---------       ----
> 291     199502  5               SNAPSHOTS/01-16-14
>
> yet, oddly enough btrfs sub del really doesn't want to delete it, even
> though it's entirely empty and not in use either.
>
> # btrfs sub del /mnt/1/SNAPSHOTS/01-16-14
> Transaction commit: none (default)
> Delete subvolume '/mnt/1/SNAPSHOTS/01-16-14'
> ERROR: cannot delete '/mnt/1/SNAPSHOTS/01-16-14' - Directory not empty

We have a pretty long list of reasons why the delete will fail, but the 
not empty one should only pop up if we think this snapshot has a 
reference on something else.  I wonder if the mv didn't drop the refs.

The easiest way to clear it up is with btrfs-debug-tree.

If you're on a recent btrfs-progs:

btrfs-debug-tree -d /dev/xxxx > output.txt

gzip and send to me (privately).  It wont' contain any if your personal 
data, just the subvolume layout.

-chris
