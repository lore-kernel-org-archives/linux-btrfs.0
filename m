Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35256 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932588AbcKHWg2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 17:36:28 -0500
Received: by mail-wm0-f45.google.com with SMTP id a197so273981379wmd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 14:36:28 -0800 (PST)
Date: Tue, 8 Nov 2016 23:36:25 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: James Pharaoh <james@wellbehavedsoftware.com>
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161108233625.1eff15df@system>
In-Reply-To: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 6 Nov 2016 14:30:52 +0100, James Pharaoh
<james@wellbehavedsoftware.com> wrote :

> Hi all,
> 
> I'm pleased to announce my btrfs deduplication utility, written in
> Rust. This operates on whole files, is fast, and I believe
> complements the existing utilities (duperemove, bedup), which exist
> currently.
> 
> Please visit the homepage for more information:
> 
> http://btrfs-dedupe.com
> 

Thanks for having shared your work.
Please be aware of these other similar softwares:
- jdupes: https://github.com/jbruchon/jdupes
- rmlint: https://github.com/sahib/rmlint
And of course fdupes.

Some intesting points I have seen in them:
- use xxhash to identify potential duplicates (huge speedup)
- ability to deduplicate read-only snapshots
- identify potential reflinked files (see also my email here:
  https://www.spinics.net/lists/linux-btrfs/msg60081.html)
- ability to filter out hardlinks
- triangle problem: see jdupes readme
- jdupes has started the process to be included in Debian

I hope that will help and that you can share some codes with them !

