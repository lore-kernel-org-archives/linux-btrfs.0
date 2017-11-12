Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:45420 "EHLO
        resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750984AbdKLVGz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 16:06:55 -0500
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Robert White <rwhite@pobox.com>
Subject: Theoretical Question about commit=n
Message-ID: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
Date: Sun, 12 Nov 2017 20:58:46 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is the commit interval monotonic, or is it seconds after sync?

What I mean is that if I manually call sync(2) does the commit timer
reset? I'm thinking it does not, but I can imagine a workload where it
ideally would.

(Again, this is purely theoretical, I have no such workload as I am
about to describe.)

So suppose I have some sort of system, like a database, that I know will
do scattered writes and extends through some files and then call some
variant of sync(2). And I know that those sync() calls will be every
forty-to-sixty seconds because of reasons. It would be "neat" to be able
to set the commit=n to some high value, like 90, and then "normally" the
sync() behaviours would follow the application instead of the larger
commit interval.

The value would be that the file system would tend _not_ to go into sync
while the application was still skittering about in the various files.

Of course any other applications could call sync from their own contexts
for their own reasons. And there's an implicit fsync() on just about any
close() (at least if everything is doing its business "correctly")

It may be a strange idea but I can think of some near realtime
applications might be able to leverage a modicum of control over the
sync event. There is no API, and not strong reason to desire one, for
controlling the commit via (low privelege) applications.

But if the plumbing exists, then having a mode where sync() or fsync()
(which I think causes a general sync because of the journal) resets the
commit timer could be really interesting.

With any kind of delayed block choice/mapping it could actually reduce
the entropy of the individual files for repeated random small writes.
The application would have to be reasonably aware, of course.

Since something is causing a sync() the commit=N guarantee is still
being met for the whole system for any N, but applications could tend to
avoid mid-write commits by planing their sync()s.

Just a thought.
