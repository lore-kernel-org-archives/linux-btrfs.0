Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753361AbeARQyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 11:54:00 -0500
Date: Thu, 18 Jan 2018 17:51:50 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/10] bugfixes and regression tests of
 btrfs_get_extent
Message-ID: <20180118165150.GR13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180108195734.GO13726@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180108195734.GO13726@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 08:57:34PM +0100, David Sterba wrote:
> On Fri, Jan 05, 2018 at 12:51:07PM -0700, Liu Bo wrote:
> > Although
> > commit e6c4efd87ab0 ("btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map")
> > fixed up the negetive em->len, it has introduced several regressions, several has been fixed by
> > 
> > commit 32be3a1ac6d0 ("btrfs: Fix the wrong condition judgment about subset extent map"),
> > commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map insertion in btrfs_get_extent") and
> > commit 8e2bd3b7fac9 ("Btrfs: deal with existing encompassing extent map in btrfs_get_extent()").
> > 
> > Unfortunately, there is one more regression which is caught recently by a
> > user's workloads.
> > 
> > While debugging the above issue, I found that all of these bugs are caused
> > by some racy situations, which can be very tricky to reproduce, so I
> > created several extent map specific test cases in btrfs's selftest
> > framework.
> > 
> > Patch 1-2 are fixing two bugs.
> > Patch 3-4 are some preparatory work.
> > Patch 3-5 are regression tests about the logic of handling EEXIST from
> > adding extent map.
> > Patch 8-10 are debugging wise, one is a direct tracepoint and the other is
> > to enable kprobe on merge_extent_mapping.
> > 
> > v2:
> > - Improve commit log to provide more details about the bug.
> > - Adjust bugfixes to the front so that we can merge them firstly.
> 
> Patchset updated in for-next. Expected merge target is 4.16, review is
> still needed (and welcome).

Patchset added to 4.16.
