Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753582AbeBWUbB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 15:31:01 -0500
Date: Fri, 23 Feb 2018 21:28:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/27] btrfs-progs: introduce libbtrfsutil,
 "btrfs-progs as a library"
Message-ID: <20180223202841.GL1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <20180220185048.GR10193@twin.jikos.cz>
 <20180221151338.GF1469@twin.jikos.cz>
 <20180221185032.GA879@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221185032.GA879@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 10:50:32AM -0800, Omar Sandoval wrote:
> On Wed, Feb 21, 2018 at 04:13:38PM +0100, David Sterba wrote:
> > On Tue, Feb 20, 2018 at 07:50:48PM +0100, David Sterba wrote:
> > > I have more comments or maybe questions about the future development
> > > workflow, but at this point the patchset is in a good shape for
> > > incremental merge.
> > 
> > After removnig the first patch adding subvolume.c (with
> > linux/btrfs_tree.h) and what depends on it, I'm left with:
> > 
> > Omar Sandoval (4):
> >       Add libbtrfsutil
> >       libbtrfsutil: add Python bindings
> >       libbtrfsutil: add qgroup inheritance helpers
> >       libbtrfsutil: add filesystem sync helpers
> > 
> > with some context updates. That builds and passes the CI tests.
> 
> Great. Does the CI system run the Python tests yet?

Tested here https://travis-ci.org/kdave/btrfs-progs/jobs/345410536 ,
does not pass.


test_start_sync (test_filesystem.TestSubvolume) ... mkfs.btrfs: invalid option -- 'q'
usage: mkfs.btrfs [options] dev [ dev ... ]


Looks like it tries to use the system mkfs.btrfs that is old.
