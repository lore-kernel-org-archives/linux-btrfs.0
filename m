Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33198 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2LIJH3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 04:07:29 -0500
Received: by mail-ie0-f171.google.com with SMTP id 17so6842113iea.30
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Dec 2012 01:07:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121203113547.GA19321@suse.de>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
	<20121203113547.GA19321@suse.de>
Date: Sun, 9 Dec 2012 11:00:14 +0200
Message-ID: <CAOcd+r09rZ5NvvTgAobex6i+84xSz8ApDzo37hHO9LdcQ1DNNA@mail.gmail.com>
Subject: Re: Snapper snapshot comparison algorithm - send/receive questions
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Arvin Schnell <aschnell@suse.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arvin,

On Mon, Dec 3, 2012 at 1:35 PM, Arvin Schnell <aschnell@suse.de> wrote:
> On Sat, Dec 01, 2012 at 01:24:20PM +0530, nafisa mandliwala wrote:
>
>> I needed help with understanding the snapshot comparison algorithm
>> that snapper uses and its shortcomings. From reading the code, what I
>> understood is that it does a block by block compare. I'm not very sure
>> if that's the best way to go about it. Also, since the send receive
>> code is still in development stages, is there a scope to add more
>> functionality to it?
>
> Mainly snapper does a directory traversal and a block-by-block
> comparison of files which is indeed a inefficient comparison
> algorithm.
>
> I already had a look at using the new send/receive ioctl to
> improve the comparison and have a few question:
>
> 1. snapper only needs to know that a file has changed but the
>    send stream also contains the new content which might has to
>    be read from disk.
>
>    Mark Fasheh has made a patch for a flag for the send ioctl to
>    not include the content (don't know if he posted it here since
>    I was kicked of the list twice). With no write commands in the
>    stream how can I detect a file content change? Currently there
>    seems to be a truncate after the write but is that guaranteed?
>
>    Btw: There are many apparently useless truncates, e.g. after a
>    chmod. What are these good for?

Currently, any S_ISREG() file (i.e., not a directory, symlink etc.)
that is considered as changed, will have a truncate command to ensure
correct file size at the receive side. There may perhaps be room for
optimization here, though.


>
> 2. Is it possible to add a ioctl for send that takes open
>    file-descriptors for parent_root and clone_sources? Otherwise
>    it's insecure to use from snapper (which has root privileges
>    and sometimes operates in directories users can modify). Such
>    a ioctl would also reduce the number of btrfs related
>    functions needed.
>
> 3. Overall lots of functions are needed to use the
>    send/receive. Are there any plans to create a btrfs-library
>    that contains the required functions
>    e.g. btrfs_read_and_process_send_stream, subvol_uuid_search
>    and tree_search?
>
> Regards,
>   Arvin
>

Alex.
