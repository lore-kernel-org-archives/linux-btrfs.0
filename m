Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:49283 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbdBSKZ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Feb 2017 05:25:27 -0500
Date: Sun, 19 Feb 2017 11:25:24 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs Heatmap - v5 ... snake, linear ... the virtual address
 space
Message-ID: <20170219102524.2bzchm326o7uvviw@angband.pl>
References: <c26fb483-6348-e4a0-d9aa-4363aac063a1@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c26fb483-6348-e4a0-d9aa-4363aac063a1@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 19, 2017 at 01:01:29AM +0100, Hans van Kranenburg wrote:
> I just tagged v5 of the Btrfs Heatmap utility, which visualizes the
> usage of your btrfs filesystem

> Since I got tired of cloning and updating the thing all over the place,
> I added debian packaging. I'm planning to get all of it into Debian
> unstable after the Stretch release.

Why would you wait until after the release?  For packages not in testing,
unstable is fully open.  NEW processing is somewhat sluggish, but the hard
part, getting there, is full of bored people who can help.  Not sure if you
have a pet DD around -- if not, I for one can help with review/upload.

> For the impatient, use pbuilder or grab it from our repo at $dayjob:
> http://packages.mendix.com/debian/pool/main/b/btrfs-heatmap/
> http://packages.mendix.com/debian/pool/main/p/python-btrfs/

Here's a brief review:

There's a bunch of issues caught by automated tools.  You can run "lintian
-i *.changes", both on source and binary packages.  With -i, lintian gives
a helpful explanation how to fix problems it finds.

btrfs-headmap:
"Section" shouldn't be "python", it's merely written in python, not a
    library or a python-specific tool
man page should explain what the image says (colors, etc).

python-btrfs:
The python team wants to get rid of python2 as soon as possible.  As there's
no legacy code using this package, what's the point of providing python2
versions?


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
