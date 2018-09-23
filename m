Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:56928
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726520AbeIXDx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Sep 2018 23:53:26 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v10 preview... detailed usage reporting and a tutorial
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
Date: Sun, 23 Sep 2018 23:54:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm planning for a python-btrfs release to happen in a about week.

All new changes are in the develop branch:
https://github.com/knorrie/python-btrfs/commits/develop

tl;dr: check out the two new examples added in the latest git commits
and see if they provide correct info!

## Detailed usage reporting

The new FsUsage object provides information on different levels
(physical allocated bytes on devices, virtual space usage, etc) and also
contains code to estimate how much space is still actually really
available before ENOSPC happens. (e.g. the values that would ideally
show up in df output). It works for all allocation profiles!

Two examples have been added, which use the new code. I would appreciate
extra testing. Please try them and see if the reported numbers make sense:

space_calculator.py
-------------------
Best to be initially described as a CLI version of the well-known
webbased btrfs space calculator by Hugo. ;] Throw a few disk sizes at
it, choose data and metadata profile and see how much space you would
get to store actual data.

See commit message "Add example to calculate usable and wasted space"
for example output.

show_usage.py
-------------
The contents of the old show_usage.py example that simply showed a list
of block groups are replaced with a detailed usage report of an existing
filesystem.

See commit message "A new show usage example!" for example output.

## A btrfs tutorial!

A while ago I started creating documentation for python-btrfs in
tutorial style. By playing around with an example filesystem we learn
where btrfs puts our data on the disks, what a chunk, block group and an
extent is, how we can quickly look up interesting things in metadata and
how cows climb trees, moo.

https://github.com/knorrie/python-btrfs/issues/11
https://github.com/knorrie/python-btrfs/blob/tutorial/tutorial/README.md

I'm not sure yet if I'm going to 'ship' the first few pages already,
since it's still very much a work in progress, but in any case feedback
/ ideas are welcome. Have a look!

## Other changes

Other changes are the addition of the sync, fideduperange and
get_features ioctl calls and a workaround for python 3.7 which breaks
the struct module api.

## P.S.

And finally, when doing the above, I discovered a few extra unintended
features and bugs in the btrfs chunk allocator (Did you know RAID10
block groups are limited to 5GiB in size? Did you know that when the
last chunk added on a disk is of DUP type, it could end up having an end
beyond the limit of a device?).

I still have to actually test the second one, causing it to happen.
If anyone is interested to help with that, please ask about it.

The bugs are all related to repeated kernel code all over the place
containing a lot of if statements dealing with different kind of
allocation profiles and their exceptions. What I ended up doing is
making a few helper functions instead, see the commit "Add volumes.py,
handling device / chunk logic". It would probably be nice to do the same
in the kernel code, which would also solve the mentioned bugs and
prevent new similar ones from happening.

Have fun,
-- 
Hans van Kranenburg
