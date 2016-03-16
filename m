Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38197 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520AbcCPESG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 00:18:06 -0400
Received: by mail-ig0-f173.google.com with SMTP id ig19so32442324igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 21:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
	<CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
	<5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
	<CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
	<1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
Date: Tue, 15 Mar 2016 22:18:04 -0600
Message-ID: <CAJCQCtTNO_BydLdKcZh_Ebv5ie2=mRfkosUTHH+ZSu003zwq+A@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: nazar@mokrynskyi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Very simplistically: visualizing Btrfs writes without file deletion,
it's a contiguous write. There isn't much scatter, even accounting for
metadata and data chunk writes happening in slightly different regions
of platter space. (I'm thinking this slow down happens overwhelmingly
on HDDs.)

If there are file deletions, holes appear, and now some later writes
will fill those holes, but not exactly, which will lead to
fragmentation and thus seek times. Seeks would go up by a lot the
smaller the holes are. And the holes are smaller the fewer files are
being deleted at once.

If there's a snapshot, and then file deletions, holes don't appear.
Everything is always copy on write and deleted files don't actually
get deleted (they're still in another subvolume). So as soon as a file
is reflinked or in a snapshotted subvolume there's no fragmentation
happening with file deletions.

If there's many snapshots happening in a short time, such as once
every 10 minutes, that means only 10 minutes worth of writes happening
in a given subvolume. If that space is later released by deleting
snapshots one at time (like a rolling snapshot and delete strategy
every 10 minutes) that means only small holes are opening up for later
writes. It's maybe the worst case scenario for fragmenting Btrfs.

A better way might be to delay snapshot deletion. Keep taking the
snapshots, but delete old snapshots in batches. Delete maybe 10 or 100
(if we're talking thousands of snapshots) at once. This should free a
lot more contiguous space for later writes and significantly reduce
the chance of significant fragmentation. Of course some fragmentation
is going to happen no matter what, but I think the usage pattern
described in a lot of these slow down cases sound to me like worse
case scenario for cow.

Now, a less lazy person would actually test this hypothesis.


Chris Murphy
