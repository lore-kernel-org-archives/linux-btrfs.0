Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35342 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcFFA41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 20:56:27 -0400
Received: by mail-oi0-f44.google.com with SMTP id w184so203946929oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 17:56:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465005092.6648.39.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
Date: Sun, 5 Jun 2016 18:56:26 -0600
Message-ID: <CAJCQCtQHiXa1fsc1nVFYsd0YK=vg5aaMLPTcDijpXLBxi6yrjQ@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 7:51 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> I think I remember that you've claimed that last time already, and as
> I've said back then:
> - what counts is probably the common understanding of the term, which
>   is N disks RAID1 = N disks mirrored
> - if there is something like an "official definition", it's probably
>   the original paper that introduced RAID:
>   http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf
>   PDF page 11, respectively content page 9 describes RAID1 as:
>   "This is the most expensive option since *all* disks are
>   duplicated..."


You've misread the paper.

It defines what it means by "all disks are duplicated" as G=1 and C=1.
That is, every data disk has one check disk. That is, two copies.
There is no mention of n-copies.

Further in table 2 "Characteristics of Level 1 RAID" the overhead is
described as 100%, and the usable storage capacity is 50%. Again, that
is consistent with duplication.

The definition of duplicate is "one of two or more identical things."

The etymology of duplicate is "1400-50; late Middle English < Latin
duplicātus (past participle of duplicāre to make double), equivalent
to duplic- (stem of duplex) duplex + -ātus -ate1
http://www.dictionary.com/browse/duplicate

There is no possible reading of this that suggests n-way RAID is intended.




-- 
Chris Murphy
