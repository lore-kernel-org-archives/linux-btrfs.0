Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:53698 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdBGUCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 15:02:25 -0500
Date: Wed, 8 Feb 2017 00:57:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Peter Zaitsev <pz@percona.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS for OLTP Databases
Message-ID: <20170208005740.3913b1d0@natsu>
In-Reply-To: <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 7 Feb 2017 09:13:25 -0500
Peter Zaitsev <pz@percona.com> wrote:

> Hi Hugo,
> 
> For the use case I'm looking for I'm interested in having snapshot(s)
> open at all time.  Imagine  for example snapshot being created every
> hour and several of these snapshots  kept at all time providing quick
> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
> think you also describe)  nodatacow  does not provide any advantage.

It still does provide some advantage, as in each write into new area since
last hour snapshot is going to be CoW'ed only once, as opposed to every new
write getting CoW'ed every time no matter what.

I'm not sold on autodefrag, what I'd suggest instead is to schedule regular
defrag ("btrfs fi defrag") of the database files, e.g. daily. This may increase
space usage temporarily as it will partially unmerge extents previously shared
across snapshots, but you won't get away runaway fragmentation anymore, as you
would without nodatacow or with periodical snapshotting.

-- 
With respect,
Roman
