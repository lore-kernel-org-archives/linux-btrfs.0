From: calin <calin@splitreflection.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 10:37:14 -0700
Message-ID: <20081021173714.29505.qmail@splitreflection.com>
Reply-To: calin@splitreflection.com
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> question is: if you had such an implementation, are there
> drawbacks expectable for the single-mount case? If not I'd vote for it
> because there are not really many alternatives "on the market".

As I understand it, the largest issue is in locking and boundaries.  Two different systems could mount a filesystem, and try to use some sort of on-disk markers to keep from writing to the same area at the same time... but there is often some bit of time between when a system sends data to the disk and when it would become available to read from the disk, and little or no guarantee about the order in which the data is written.  All the work that goes into making transactions atomic depends on there only being a single path to the disk - through the code that handles transactions.  If data can arrive on the disk without being managed by that code, all bets are off.
