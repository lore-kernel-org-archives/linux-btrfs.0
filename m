Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44913 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdBSO0f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Feb 2017 09:26:35 -0500
Subject: Re: Btrfs Heatmap - v5 ... snake, linear ... the virtual address
 space
To: Adam Borowski <kilobyte@angband.pl>
References: <c26fb483-6348-e4a0-d9aa-4363aac063a1@mendix.com>
 <20170219102524.2bzchm326o7uvviw@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5ac66e3b-909b-cb18-1766-bcc8d6b8f6ff@mendix.com>
Date: Sun, 19 Feb 2017 15:24:59 +0100
MIME-Version: 1.0
In-Reply-To: <20170219102524.2bzchm326o7uvviw@angband.pl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/19/2017 11:25 AM, Adam Borowski wrote:
> On Sun, Feb 19, 2017 at 01:01:29AM +0100, Hans van Kranenburg wrote:
>> I just tagged v5 of the Btrfs Heatmap utility, which visualizes the
>> usage of your btrfs filesystem
> 
>> Since I got tired of cloning and updating the thing all over the place,
>> I added debian packaging. I'm planning to get all of it into Debian
>> unstable after the Stretch release.
> 
> Why would you wait until after the release?  For packages not in testing,
> unstable is fully open.

Ah. I see.

> NEW processing is somewhat sluggish, but the hard
> part, getting there, is full of bored people who can help.  Not sure if you
> have a pet DD around -- if not, I for one can help with review/upload.

Nope. That would be great, I would really appreciate that.

>> For the impatient, use pbuilder or grab it from our repo at $dayjob:
>> http://packages.mendix.com/debian/pool/main/b/btrfs-heatmap/
>> http://packages.mendix.com/debian/pool/main/p/python-btrfs/
> 
> Here's a brief review:
> 
> There's a bunch of issues caught by automated tools.  You can run "lintian
> -i *.changes", both on source and binary packages.  With -i, lintian gives
> a helpful explanation how to fix problems it finds.

Ok.

> btrfs-headmap:
> "Section" shouldn't be "python", it's merely written in python, not a
>     library or a python-specific tool
> man page should explain what the image says (colors, etc).

Yeah, so have some more, the minimal parts of the online documentation,
in there.

> python-btrfs:
> The python team wants to get rid of python2 as soon as possible.

I see.

https://www.debian.org/doc/packaging-manuals/python-policy/ch-python3.html

> As there's
> no legacy code using this package, what's the point of providing python2
> versions?

True. Probably I should just go python 3 only anyway. If so, better
sooner than later.

It was interesting to see how much effort it would take to support both,
but it already turned into an annoyance and extra work and fragility
now. For python-btrfs, it's the fs tree which I'm working on now where
things like filenames start causing the real headaches.

> Meow!

Moo!

-- 
Hans van Kranenburg
