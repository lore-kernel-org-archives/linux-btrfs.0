Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34648 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbeBBXEN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 18:04:13 -0500
Subject: Re: [PATCH 00/26] btrfs-progs: introduce libbtrfsutil, "btrfs-progs
 as a library"
To: Hugo Mills <hugo@carfax.org.uk>, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <20180126185111.GC3807@carfax.org.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <21875b7a-4957-73c1-20b8-c4ecfc08d6c1@mendix.com>
Date: Sat, 3 Feb 2018 00:04:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180126185111.GC3807@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 01/26/2018 07:51 PM, Hugo Mills wrote:
> On Fri, Jan 26, 2018 at 10:40:48AM -0800, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> One of the features requests I get most often is a library to do the
>> sorts of operations that we do with btrfs-progs. We can shell out to
>> btrfs-progs, but the output format isn't always easily parsasble, and
>> shelling out isn't always ideal. There's libbtrfs, but it's very
>> incomplete, doesn't have a well thought out API, and is licensed under
>> the GPL, making it hard to use for many projects.
>>
>> libbtrfsutil is a new library written from scratch to address these
>> issues. The implementation is completely independent of the existing
>> btrfs-progs code, including kerncompat.h, and has a clean API and naming
>> scheme. It is licensed under the LGPL. It also includes Python bindings
>> by default. I will maintain the library code.

Insert mandatory picture here:

https://memegenerator.net/img/instances/12076366/python-all-the-things.jpg

>    *speechless*
> 
>    That's awesome, Omar (although with the python bindings, you've
> probably just ruined Hans' day ;) ).

Not quite, or should I say, quite the opposite, actually.

I can think of a few different python libs related to btrfs right now...

1. This one, which works on the same level as the btrfs-progs command
line utils and provides the same set of functionality, with the same
input and output, only way easier to handle when automating things. The
audience is the same audience as who would else try to 'shell out' to
btrfs-progs and then do painful parsing of the output.

2. A lib for advanced btrfs users (more of a niche audience) who want to
get a peek behind the curtains of what is going on in their online
filesystem. Directly do searches in metadata, directly call an ioctl
etc, either for educational purposes, or to e.g. do things like write a
small special purpose dedupe program, visualize things etc. This is the
python3-btrfs lib that I've been working on for some time now.

3. A lib for btrfs developers who want to script working on offline
fileystems. This one does not exist yet. Well, it's a bit of an unborn
baby now, my first brain dump:
  https://github.com/knorrie/btrfs-progs/blob/python/python3/README.md
This would be the lib that exposes the (to be revised and improved)
internal libbtrfs (I guess).

All of these are not competitors. They serve different purpose and a
different audience. So I'm happy to see number 1 also happening. :-)

>> Patch 1 is a preparation cleanup which can go in independently. Patch 2
>> adds the build system stuff for the library, and patch 3 does the same
>> for the Python bindings. Patches 4-14 implement the library helpers,
>> currently subvolume helpers and the sync ioctls. Patches 15-26 replace
>> the btrfs-progs and libbtrfs code to use libbtrfsutil instead. I took
>> care to preserve backwards-compatibility. `btrfs subvol list` in
>> particular had some buggy behaviors for -o and -a that I emulated in the
>> new code, see the comments in the code.

+1 for starting to clean up that code. Especially the whole subvolume
list part looks like a great improvement.

>> These patches are also available on my GitHub:
>> https://github.com/osandov/btrfs-progs/tree/libbtrfsutil. That branch
>> will rebase as I update this series.
>>
>> Please share feedback regarding the API, implementation, or anything
>> else.

Great work, and I'm of course also interested in what you think about
the lib nr.3 idea, since I didn't throw it around on the list before
yet. :-)

-- 
Hans van Kranenburg
