From: David Brown <btrfs@davidb.org>
Subject: Re: Replacing the top-level root
Date: Wed, 27 Oct 2010 05:53:11 +0000
Message-ID: <20101027055311.GA8550@davidb.org>
References: <AANLkTiktaR6ipbH-i=kTdRvHqBdTAAcYYsdVamogifm1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktaR6ipbH-i=kTdRvHqBdTAAcYYsdVamogifm1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 03:20:58PM -0500, C Anthony Risinger wrote:

>For example, right now extlinux support booting btrfs, but _only_ from
>the top-level root.  if i just had a way to "swap" the top-level root
>with a different subvol, i could overcome several problems i have with
>users all at once:
>
>) users install their system to the top-level root, which means it is
>no longer manageable by snapshot scripts [currently]
>) if the top-level root could be swapped, extlinux could then boot my
>snapshot? (i'm probably wrong here)

I don't think this is a solution to the extlinux problem, but I've
moved roots into new subvolumes, basically something like this.

Root is mounted as /, I've also mounted the volume on /mounted in this
example.

   # btrfs subvolume snapshot /mounted /mounted/newrootname

Now reboot, adding the subvol option to use the newrootname.  

Go into /mounted and make sure files touced there don't show up in '/'
(we really are mounting the submount).

Then just use rm -rf to remove everything that isn't a subvol.  I
don't know of an easy way to do that, and be careful.

This doesn't really change the default root, but by making a snapshot
of it, can move all of the data elsewhere.

David
