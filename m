Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33523 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaFLPnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 11:43:47 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so792810lbi.23
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 08:43:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5398F5B9.3000207@fb.com>
References: <1402531956-27668-1-git-send-email-fdmanana@gmail.com>
	<5398F5B9.3000207@fb.com>
Date: Thu, 12 Jun 2014 16:43:45 +0100
Message-ID: <CAL3q7H5+0MMXiqREDon8B5-m4tpp1uPvtrf4wwCo-6gOeCJN7A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix qgroups sanity test crash or hang
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 12, 2014 at 1:35 AM, Chris Mason <clm@fb.com> wrote:
> On 06/11/2014 08:12 PM, Filipe David Borba Manana wrote:
>> Often when running the qgroups sanity test, a crash or a hang happened.
>> This is because the extent buffer the test uses for the root node doesn't
>> have an header level explicitly set, making it have a random level value.
>> This is a problem when it's not zero for the btrfs_search_slot() calls
>> the test ends up doing, resulting in crashes or hangs such as the following:
>>
>
>> Therefore initialize the extent buffer as an empty leaf (level 0).
>>
>> Issue easy to reproduce when btrfs is built as a module via:
>>
>>     $ for ((i = 1; i <= 1000000; i++)); do rmmod btrfs; modprobe btrfs; done
>
> Nice, thanks Filipe, I hadn't been able to trigger this yet.

It's a bit rare for me too, happens about 1/100 in my vm. Every time
it fails root->node's header level is a non-zero value, usually way
bigger than BTRFS_MAX_LEVEL (8), causing all sorts of badness in
btrfs_search_slot() due to out of bounds accesses to the arrays
path->{locks | nodes | slots}

>
> -chris



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
