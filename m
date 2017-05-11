Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:36624 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbdEKTWD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 15:22:03 -0400
Date: Fri, 12 May 2017 00:22:00 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marat Khalili <mkh@rqc.ru>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Backing up BTRFS metadata
Message-ID: <20170512002200.73d5207f@natsu>
In-Reply-To: <CAJCQCtTbE6M23e8EmB23pp89Y8673BeY+p_tkox3orY-AS2DJQ@mail.gmail.com>
References: <2b29db76-9199-0759-3477-58f0a67a3570@rqc.ru>
        <CAJCQCtTbE6M23e8EmB23pp89Y8673BeY+p_tkox3orY-AS2DJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 May 2017 09:19:28 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> On Thu, May 11, 2017 at 8:56 AM, Marat Khalili <mkh@rqc.ru> wrote:
> > Sorry if question sounds unorthodox, Is there some simple way to read (and
> > backup) all BTRFS metadata from volume?
> 
> btrfs-image

Hm, I thought that's for debugging only, and that you can't actually restore
metadata onto a data-containing FS and have anything mountable/readable as a
result.

Seems not to be the case, and in fact, could this be one of the "missing
links" in the Fsck story, 

       -w
           Walk all the trees manually and copy any blocks that are
           referenced. Use this option if your extent tree is corrupted to
           make sure that all of the metadata is captured.

This certainly does sound like something to try for some of those broken
filesystems where Btrfsck refuses to do anything. Save image with this manual
walking/reconstruction of the trees, then restore. Too bad I already nuked
mine, so can't experiment with that.

-- 
With respect,
Roman
