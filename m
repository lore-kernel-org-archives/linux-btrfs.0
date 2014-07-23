Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54163 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbaGWQEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 12:04:08 -0400
Received: by mail-oa0-f52.google.com with SMTP id o6so1916758oag.11
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 09:04:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140722141526.GZ1553@twin.jikos.cz>
References: <CALOYprVQDbA1jGgaMmJrM7tOJKRSpfgbHF88=ccaKLRzsNs7vQ@mail.gmail.com>
	<20140722141526.GZ1553@twin.jikos.cz>
Date: Wed, 23 Jul 2014 17:04:08 +0100
Message-ID: <CALOYprUcvJdOm=foeauXzNt3jRGd_c6=2TzXz+WAeLB4AtKRVA@mail.gmail.com>
Subject: Re: Unstable v3.15-rc tags
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 July 2014 15:15, David Sterba <dsterba@suse.cz> wrote:
> The tags were meant to mark the points in time where different groups of
> patches were added to the to-be-v3.15, but then I noticed that one of
> the patches had my note in the subject and Qu sent an updated version
> anyway. So I had rebased the branch and all the tags became stale. I did
> not bother to move them as they did not work as expected.

Ah, thanks for clarifying. I wasn't particularly attached to the tags,
it just seemed odd that we got to rc4, then dropped back down to rc1.
I'll not pay too much attention to them in future.

>
> The patch flux is the good and bad habit of the integration repository.

It certainly makes for an interesting chart in gitk --all. :-D

Cheers,


WorMzy
