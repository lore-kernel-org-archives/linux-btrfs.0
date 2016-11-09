Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35559 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbcKIMrz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Nov 2016 07:47:55 -0500
Received: by mail-wm0-f67.google.com with SMTP id a20so18271810wme.2
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Nov 2016 04:47:54 -0800 (PST)
Date: Wed, 9 Nov 2016 13:47:51 +0100
From: Saint Germain <saintger@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Cc: =?ISO-8859-1?B?TmljY29s8g==?= Belli <darkbasic@linuxsystems.it>
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161109134751.434b5e83@system>
In-Reply-To: <8f0cf023-7189-4de1-a72c-38a4deb8a049@linuxsystems.it>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
        <20161108233625.1eff15df@system>
        <8f0cf023-7189-4de1-a72c-38a4deb8a049@linuxsystems.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 09 Nov 2016 12:24:51 +0100, Niccolò Belli
<darkbasic@linuxsystems.it> wrote :
> 
> On martedì 8 novembre 2016 23:36:25 CET, Saint Germain wrote:
> > Please be aware of these other similar softwares:
> > - jdupes: https://github.com/jbruchon/jdupes
> > - rmlint: https://github.com/sahib/rmlint
> > And of course fdupes.
> >
> > Some intesting points I have seen in them:
> > - use xxhash to identify potential duplicates (huge speedup)
> > - ability to deduplicate read-only snapshots
> > - identify potential reflinked files (see also my email here:
> >   https://www.spinics.net/lists/linux-btrfs/msg60081.html)
> > - ability to filter out hardlinks
> > - triangle problem: see jdupes readme
> > - jdupes has started the process to be included in Debian
> >
> > I hope that will help and that you can share some codes with them !
> > 
> Hi,
> What do you think about jdupes? I'm searching an alternative to
> duperemove and rmlint doesn't seem to support btrfs deduplication, so
> I would like to try jdupes. My main problem with duperemove is a
> memory leak, also it seems to lead to greater disk usage: 
> https://github.com/markfasheh/duperemove/issues/163

rmlint is supporting btrfs deduplication:
rmlint --algorithm=xxhash --types="duplicates" --hidden --config=sh:handler=clone --no-hardlinked

I've used jdupes and rmlint to deduplicate 2TB with 4GB RAM and it took
a few hours. So it is acceptable from a performance point of view.
The problems I found have been corrected by both.

Jdupes author is really kind and reactive !
