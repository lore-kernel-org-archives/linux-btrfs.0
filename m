Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:37454 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbeHOO1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 10:27:31 -0400
Received: by mail-qk0-f179.google.com with SMTP id t79-v6so496021qke.4
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 04:35:41 -0700 (PDT)
Subject: Re: How to ensure that a snapshot is not corrupted?
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAN4oSBd9aVn9Ruv83fd=oE4hJhGw7y3f1EbJ+SNbHMZZyZo=Mw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8e8d23d9-ce7a-5f67-c8e1-d7c1d044178a@gmail.com>
Date: Wed, 15 Aug 2018 07:35:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAN4oSBd9aVn9Ruv83fd=oE4hJhGw7y3f1EbJ+SNbHMZZyZo=Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-10 06:07, Cerem Cem ASLAN wrote:
> Original question is here: https://superuser.com/questions/1347843
> 
> How can we sure that a readonly snapshot is not corrupted due to a disk failure?
> 
> Is the only way calculating the checksums one on another and store it
> for further examination, or does BTRFS handle that on its own?
> 
I've posted an answer for the linked question on SuperUser, under the 
assumption that it will be more visible to people simply searching for 
it there than it would be on the ML.

Here's the text of the answer though so people here can see it too:

There are two possible answers depending on what you mean by 'corrupted 
by a disk failure'.

### If you mean simple at-rest data corruption

BTRFS handles this itself, transparently to the user.  It checksums 
everything, including data in snapshots, internally and then verifies 
the checksums as it reads each block.  There are a couple of exceptions 
to this though:

* If the volume is mounted with the `nodatasum` or `nodatacow` options, 
you will have no checksumming of data blocks.  In most cases, you should 
not be mounting with these options, so this should not e an issue.
* Any files for which the `NOCOW` attribute is set (`C` in the output of 
the `lsattr` command) are also not checked.  You're not likely to have 
any truly important files with this attribute set (systemd journal files 
have it set, but that's about it unless you set it manually).

### If you mean non-trivial destruction of data on the volume because of 
loss of too many devices

You can't protect against this except by having another copy of the data 
somewhere.  Pretty much, if you've lost more devices than however many 
the storage profiles for the volume can tolerate, your data is gone, and 
nothing is going to get it back for you short of restoring from a backup.
