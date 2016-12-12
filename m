Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34688 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbcLLEMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 23:12:38 -0500
Received: by mail-yw0-f178.google.com with SMTP id t125so56109793ywc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 20:12:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
 <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
 <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
 <CADph71yACvRhb6AWixoaR28+VHZeaGmZqawqY3MSBcSeJM=6Qw@mail.gmail.com>
 <CAJCQCtT1y+j2d9x907CZaT+g-21nQ1MkC1gR9eJdZ5xPRuPAng@mail.gmail.com>
 <CADph71xdM4A2zd0ACmm4GNVp=Jwdp7935q9ur8bkha4+PmVSHg@mail.gmail.com> <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 21:12:36 -0700
Message-ID: <CAJCQCtQ0niBwPjVyR8G2Lkyu3-yCzkAiD8cN1WHEVezG0xrP3Q@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Markus Binsteiner <makkus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another idea is btrfs-find-root -a. This is slow for me, it took about
a minute for less than 1GiB of metadata. But I've got over 50
candidate tree roots and generations.

But still you can try the tree root for the oldest generation in your
full superblock listing, like I described. If that restore dry run is
an empty listing, or partial, then try the btrfs-find-root -a option
to get more candidate generations. For the most part each lower
generation number is 30 seconds older. So if you can think about when
you umounted the file system in relation to when the delete happened,
you can get closer to the most recent generation that still has your
data.


Chris Murphy
