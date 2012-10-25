Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42652 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab2JYNSS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 09:18:18 -0400
Message-ID: <50893C1E.6020106@oracle.com>
Date: Thu, 25 Oct 2012 21:18:22 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Richard Hughes <hughsient@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Naming of subvolumes
References: <1351168220.1923.6.camel@hughsie-work.lan>
In-Reply-To: <1351168220.1923.6.camel@hughsie-work.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Richard,

On 25/10/2012 20:30, Richard Hughes wrote:
> I'm planning to use "btrfs subvolume snapshot -r<name>" in the system
> upgrade functionality[1] if the user is using btrfs for their root file
> system. We've got most of the bits in place already for Fedora 18.
>
> One think that confuses me is the convention for the naming of
> snapshots. Is there any conventions or prior art there? Can I add
> metadata to the snapshot so that I don't have encode everything in the
> snapshot name itself?

  I have an experimental-patch to add tag for the snapshot.
  I can send it to you for a review (but I doubt if its any near
  for the integration, since it changes the root_info structure
  and I want to know if there is any better place to store
  the tag for the snapshots (like if its better to allocate
  a chunk to place this and all other properties in a xml format ?))

> Also, being able to do a snapshot using a libbtrfs (or whatever) would
> be much preferable to exec'ing the btrfs command and then trying to
> parse the exit code and any stderr.

   Its planned. At least for the functions surrounding the snapshots.

> I don't know if this kind of thing
> is the norm for filesystem utilities, but a versioned shared library to
> use would be awesome.
>
> Any advice welcome, thanks.
>
> Richard
> (PackageKit author)
>
> [1] https://fedoraproject.org/wiki/Features/OfflineSystemUpdates

   Other things which might be useful are
     - default location for the snapshots which can be reset
       using the btrfs set cli or lib.
     - default name for the snapshots.
     - A pre-defined profile for the snapshots
       (eg. Snapshots taken for backup may need to
        bypass the read-cache, when read)

Thanks, Anand

