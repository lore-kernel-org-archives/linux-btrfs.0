Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37254 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbcEPMjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:39:12 -0400
Received: by mail-ig0-f177.google.com with SMTP id s8so38741930ign.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 05:39:11 -0700 (PDT)
Subject: Re: RFE: 'btrfs' tools machine readable output
To: "Richard W.M. Jones" <rjones@redhat.com>, linux-btrfs@vger.kernel.org
References: <20160516121456.GA16970@redhat.com>
Cc: ptoscano@redhat.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1c0d1dbc-325b-829a-762c-67288bb957a3@gmail.com>
Date: Mon, 16 May 2016 08:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20160516121456.GA16970@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-16 08:14, Richard W.M. Jones wrote:
> I don't have time to implement this right now, so I'm just posting
> this as a suggestion/request ...
>
> It would be really helpful if the btrfs tools had a machine-readable
> output.
>
> Libguestfs parses btrfs tools output in a number of places, eg:
> https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c
> This is a massive PITA because each time a new release of btrfs-progs
> comes along it changes the output slightly, and we end up having
> to add all sorts of hacks.
>
> With machine-readable output, there'd be a flag which would
> change the output.  eg:
>
> $ btrfs filesystem show
> Label: 'ROOT'  uuid: af471cfc-421a-4d51-8811-ce969f76828a
>         Total devices 1 FS bytes used 5.29MiB
>         devid    1 size 767.97MiB used 92.00MiB path /dev/sda2
>
> would become:
>
> $ btrfs --json filesystem show
> {
>   "devices": {
>      "Label": "ROOT",
>      "uuid": "af471cfc-421a-4d51-8811-ce969f76828a",
>      /// etc
>   }
> }
>
> By this example I don't mean that JSON has to be the format -- in fact
> it's a terrible format with all sorts of problems -- any format which
> is parseable with C libraries would do for us.
I would love to see something like this myself, as it would make 
integration with monitoring tools so much easier.  I'd vote for YAML as 
the output format though, as it's easily human readable as well as 
machine parseable while still being space efficient.  Output from your 
example above might look something like this:
---
- filesystems
   - label: 'ROOT'
     uuid: af471cfc-421a-4d51-8811-ce969f76828a
     devices: 1
       - devid: 1
         size: 767.97 MB
         used 92.00 MB
         path: /dev/sda2
     used: 5.29 MB
...
Although of course the numbers would probably just be in bytes instead 
of 'human' values.
