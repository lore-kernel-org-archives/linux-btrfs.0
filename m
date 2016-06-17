Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35985 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbcFQWB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 18:01:56 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id 86011600D9
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jun 2016 00:01:53 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Hello world, python-btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <57647351.4010603@mendix.com>
Date: Sat, 18 Jun 2016 00:01:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

After playing around a bit for a few months with a bunch of
proof-of-concept level scripts to be able to debug my btrfs file
systems, the inevitable happened:

https://github.com/knorrie/python-btrfs/

Currently, the primary goal of this module is to be able to inspect the
internals of an existing filesystem for educational purposes.

In the last week I started sorting out the puzzle pieces I already
assembled, and put most of them together into a proper python library to
query a btrfs filesystem.

The python module acts as a wrapper around the low level kernel calls
and btrfs data structures, presenting them as python objects with
interesting attributes and references to other objects.

Using these helpers, it should be fairly easy to reimplement the same
functionality as for example btrfs fi df, btrfs fi show and btrfs
inspect-internal provide.

For example:

import btrfs
fs = btrfs.FileSystem('/')
for space in fs.space_info():
     print("{0}, {1}: total={2}, used={3}".format(
           btrfs.utils.block_group_type_str(space.flags),
           btrfs.utils.block_group_profile_str(space.flags),
           btrfs.utils.pretty_size(space.total_bytes),
           btrfs.utils.pretty_size(space.used_bytes)))

results in:

Data, single: total=15.94GiB, used=6.30GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=768.00MiB, used=158.72MiB
GlobalReserve, single: total=64.00MiB, used=0.00B

The btrfs directory in the source is the python module which is to be
imported as btrfs.

The examples directory contains example programs that use the library.
For all functionality that's added in the lib, there must be an example
program that uses it.

Currently, the code can look at devices, chunks, block groups with their
usage and lists of data extents. I usually write quite elaborate git
commit messages, so when looking through my commits or doing a git blame
on code, you should (now and later) find a nice description about the
hows whys etc of the code.

Why?!

* Because it's fun!
* Because I get sick of using horrible ducttape regex solutions to
programmatically parse human readable output of external tools to
implement monitoring tools~~!11one.
* Because I might to be able to help other people that also want to
learn the internals of btrfs.
* Much more...

How?

* It's a python library, so the code will have a decent level of
pythonicity. The ioctl search returns a generator, the search key is a
nice object you can just increment etc...
* This is a work in progress. I can only add support for parts of btrfs
that I understand myself first.

Moo!

Hans van Kranenburg

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
