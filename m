Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:44544 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbdHVRgt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 13:36:49 -0400
Date: Tue, 22 Aug 2017 22:36:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822223647.350ca27d@natsu>
In-Reply-To: <20170822165725.GL14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Aug 2017 18:57:25 +0200
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> On Tue 2017-08-22 (21:45), Roman Mamedov wrote:
> 
> > It is beneficial to not have snapshots in-place. With a local directory of
> > snapshots, issuing things like "find", "grep -r" or even "du" will take an
> > inordinate amount of time and will produce a result you do not expect.
> 
> Netapp snapshots are invisible for tools doing opendir()/readdir()
> One could simulate this with symlinks for the snapshot directory:
> store the snapshot elsewhere (not inplace) and create a symlink to it, in
> every directory.
> 
> 
> > Personally I prefer to have a /snapshots directory on every FS
> 
> My users want the snapshots locally in a .snapshot subdirectory.
> Because Netapp do it this way - for at least 20 years and we have a
> multi-PB Netapp storage environment.
> No chance to change this.

Just a side note, you do know that only subvolumes can be snapshotted on Btrfs,
not any regular directory? And that snapshots are not recursive, i.e. if a
subvolume "contains" other subvolumes (hint: it really doesn't), snapshots of
the parent one will not include content of subvolumes below that in the tree.

I don't know how Netapp does this, from the way you describe that setup it
feels like with Btrfs you're still in for some bad surprises and a part of
your expectations will not be met.

Do you plan to make each and every directory and subdirectory a subvolume (so
that it could have a trail of its own snapshots)? There will be performance
implications to that. Also deleting subvolumes can only be done via the
"btrfs" tool, they won't delete like normal dirs, e.g. when trying to do that
remotely via NFS or Samba share.

-- 
With respect,
Roman
