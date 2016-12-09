Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35112 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932313AbcLIMhE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 07:37:04 -0500
Received: by mail-io0-f196.google.com with SMTP id f73so6522421ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Dec 2016 04:37:04 -0800 (PST)
Subject: Re: autoversioning?
To: linux-btrfs@vger.kernel.org,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
References: <20161209110213.GA21685@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0219ed6f-e332-5bf1-96b9-f1b1bc09c2e7@gmail.com>
Date: Fri, 9 Dec 2016 07:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <20161209110213.GA21685@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-09 06:02, Ulli Horlacher wrote:
> Is file autoversioning possible with btrfs?
>
> I have a VMS background, where the standard filesystem automatically
> creates a new version for every file that is written.
>
> The number of versions can be controlled globally, on directory or on file
> base.
>
> With btrfs I can create manually a file version (clone) with
> "cp -a --reflink"
> but I want this to be done automatically.
>
> I could set up an incron-job (inotify), but perhaps there is a better,
> easier solution?
>
The first thing that comes to mind is a FUSE module I saw a while back 
that does this.  AFAIK, it doesn't do any reflinking, but it handles the 
COW needed for the versioning itself, so it works on any filesystem, not 
just BTRFS (and you could easily run batch deduplication from time to 
time on the backing storage so that you have things nicely reflinked). 
I sadly don't remember what the FUSE module was called though (I 
remember it because I thought the idea was neat, not because I need 
something like that), but I do distinctly remember that it exists.

Alternatively, something using fanotify would probably work better than 
both options, but it would have to be pretty smart to be reliable.
