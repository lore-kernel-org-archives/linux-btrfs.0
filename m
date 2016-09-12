Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757879AbcILNyB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:54:01 -0400
Subject: Re: Is stability a joke?
To: Waxhead <waxhead@online.no>, <linux-btrfs@vger.kernel.org>
References: <57D51BF9.2010907@online.no>
From: Chris Mason <clm@fb.com>
Message-ID: <b40d108d-004f-827b-7d4b-0b93be853e73@fb.com>
Date: Mon, 12 Sep 2016 09:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <57D51BF9.2010907@online.no>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/11/2016 04:55 AM, Waxhead wrote:
> I have been following BTRFS for years and have recently been starting to
> use BTRFS more and more and as always BTRFS' stability is a hot topic.
> Some says that BTRFS is a dead end research project while others claim
> the opposite.
>
> Taking a quick glance at the wiki does not say much about what is safe
> to use or not and it also points to some who are using BTRFS in production.
> While BTRFS can apparently work well in production it does have some
> caveats, and finding out what features is safe or not can be problematic
> and I especially think that new users of BTRFS can easily be bitten if
> they do not do a lot of research on it first.
>
> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
> of warnings and recommendations and is for me a bit better than the
> official BTRFS wiki when it comes to how to decide what features to use.
>
> The Nouveau graphics driver have a nice feature matrix on it's webpage
> and I think that BTRFS perhaps should consider doing something like that
> on it's official wiki as well
>
> For example something along the lines of .... (the statuses are taken
> our of thin air just for demonstration purposes)
>

The out of thin air part is a little confusing, I'm not sure if you're 
basing this on reports you've read?

I'm in favor flagged device replace with raid5/6 as not supported yet. 
That seems to be where most of the problems are coming in.

The compression framework shouldn't allow one to work well with the 
other unusable.

There were  problems with autodefrag related to snapshot-aware defrag, 
so Josef disabled the snapshot aware part.

In general, we put btrfs through heavy use at facebook.  The crcs have 
found serious hardware problems the other filesystems missed.

We've also uncovered performance problems and a some serious bugs, both 
in btrfs and the other filesystems.  With the other filesystems the 
fixes were usually upstream (doubly true for the most serious problems), 
and with btrfs we usually had to make the fixes ourselves.

-chris
