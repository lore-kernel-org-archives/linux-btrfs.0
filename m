From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 0/2] Fix ENOSPC regression
Date: Tue,  7 Jun 2011 16:44:07 -0400
Message-ID: <1307479449-14765-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sergei accidently introduced a regression with

c4f675cd40d955d539180506c09515c90169b15b

The problem isn't his patch, it's that we are entirely too touchy to changes in
this area because the way we deal with pressure is racy in general.  The other
problem is even though delalloc bytes are 0, we still may not have reclaimed
space, rather we need to wait for the ordered extents to reclaim the space.  So
this patch set does that and it serialize the flushers to close this race we've
always had.  This fixes normal enospc cases we were seeing.  Thanks,

Josef
