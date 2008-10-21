From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Some very basic questions
Date: Tue, 21 Oct 2008 13:23:22 +0200
Message-ID: <20081021132322.271ad728.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

reading the list for a while it looks like all kinds of implementational
topics are covered but no basic user requests or talks are going on. Since I
have found no other list on vger covering these issues I choose this one,
forgive my ignorance if it is the wrong place.
Like many people on the planet we try to handle quite some amounts of data
(TBs) and try to solve this with several linux-based fileservers.
Years of (mostly bad) experience led us to the following minimum requirements
for a new fs on our servers:

1. filesystem-check
1.1 it should not
    - delay boot process (we have to wait for hours currently)
    - prevent mount in case of errors
    - be a part of the mount process at all
    - always check the whole fs
1.2 it should be able 
    - to always be started interactively by user
    - to check parts/subtrees of the fs
    - to run purely informational (reporting, non-modifying)
    - to run on a mounted fs
2. general requirements
    - fs errors without file/dir names are useless
    - errors in parts of the fs are no reason for a fs to go offline as a whole
    - mounting must not delay the system startup significantly
    - resizing during runtime (up and down)
    - parallel mounts (very important!)
      (two or more hosts mount the same fs concurrently for reading and
      writing)
    - journaling
    - versioning (file and dir)
    - undelete (file and dir)
    - snapshots
    - run into hd errors more than once for the same file (as an option)
    - map out dead blocks
      (and of course display of the currently mapped out list)
    - no size limitations (more or less)
    - performant handling of large numbers of files inside single dirs
      (to check that use > 100.000 files in a dir, understand that it is
      no good idea to spread inode-blocks over the whole hd because of seek
      times)
    - power loss at any time must not corrupt the fs (atomic fs modification)
      (new-data loss is acceptable)

Remember, this is not meant to be a request for features, it is a list that
built up over 10 years of handling data and the failures we experienced. To
our knowledge no fs meets this list, but hey, is that a reason for not talking
about it? Our goal is pretty simple: maximize fs uptime.
How does btrfs match?
-- 
Regards,
Stephan
