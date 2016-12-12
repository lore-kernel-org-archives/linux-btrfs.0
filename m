Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36061 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbcLLEba (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 23:31:30 -0500
Received: by mail-io0-f179.google.com with SMTP id a81so144984470ioe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 20:31:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ0niBwPjVyR8G2Lkyu3-yCzkAiD8cN1WHEVezG0xrP3Q@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
 <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
 <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
 <CADph71yACvRhb6AWixoaR28+VHZeaGmZqawqY3MSBcSeJM=6Qw@mail.gmail.com>
 <CAJCQCtT1y+j2d9x907CZaT+g-21nQ1MkC1gR9eJdZ5xPRuPAng@mail.gmail.com>
 <CADph71xdM4A2zd0ACmm4GNVp=Jwdp7935q9ur8bkha4+PmVSHg@mail.gmail.com>
 <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com> <CAJCQCtQ0niBwPjVyR8G2Lkyu3-yCzkAiD8cN1WHEVezG0xrP3Q@mail.gmail.com>
From: Markus Binsteiner <makkus@gmail.com>
Date: Mon, 12 Dec 2016 17:31:28 +1300
Message-ID: <CADph71ww05nUn5NFpo92FXPJt0p0ft8sc_-AN-OTuYPC13BGhg@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2016 at 5:12 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Another idea is btrfs-find-root -a. This is slow for me, it took about
> a minute for less than 1GiB of metadata. But I've got over 50
> candidate tree roots and generations.

Same behaviour with the newer versioned btrfs-find-root, just hangs.
The older one doesn't seem to have that option.
