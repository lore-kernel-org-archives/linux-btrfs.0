Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:37084 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934320AbcKILYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Nov 2016 06:24:55 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Saint Germain <saintger@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>,
        James Pharaoh <james@wellbehavedsoftware.com>
Subject: Re: Announcing btrfs-dedupe
Date: Wed, 09 Nov 2016 12:24:51 +0100
MIME-Version: 1.0
Message-ID: <8f0cf023-7189-4de1-a72c-38a4deb8a049@linuxsystems.it>
In-Reply-To: <20161108233625.1eff15df@system>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161108233625.1eff15df@system>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
What do you think about jdupes? I'm searching an alternative to duperemove 
and rmlint doesn't seem to support btrfs deduplication, so I would like to 
try jdupes. My main problem with duperemove is a memory leak, also it seems 
to lead to greater disk usage: 
https://github.com/markfasheh/duperemove/issues/163

Niccolo' Belli

On martedì 8 novembre 2016 23:36:25 CET, Saint Germain wrote:
> Please be aware of these other similar softwares:
> - jdupes: https://github.com/jbruchon/jdupes
> - rmlint: https://github.com/sahib/rmlint
> And of course fdupes.
>
> Some intesting points I have seen in them:
> - use xxhash to identify potential duplicates (huge speedup)
> - ability to deduplicate read-only snapshots
> - identify potential reflinked files (see also my email here:
>   https://www.spinics.net/lists/linux-btrfs/msg60081.html)
> - ability to filter out hardlinks
> - triangle problem: see jdupes readme
> - jdupes has started the process to be included in Debian
>
> I hope that will help and that you can share some codes with them !
