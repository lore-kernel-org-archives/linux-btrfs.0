Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36541 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcCIUZV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 15:25:21 -0500
Received: by mail-wm0-f51.google.com with SMTP id n186so1792945wmn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 12:25:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
Date: Wed, 9 Mar 2016 15:25:19 -0500
Message-ID: <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

grr.  Gmail is terrible :-/

I understood that a btrfs RAID1 would at best grab one block from sdb
and then one block from sdd in round-robin fashion, or at worse grab
one chunk from sdb and then one chunk from sdd.  Alternatively I
thought that it might read from both simultaneously, to make sure that
all data matches, while at the same time providing single-disk
performance.  None of these was the case.  Running a single
IO-intensive process reads from a single drive.

Did I misunderstand the documentation and is this normal, or is this a bug?
Nicholas

On 9 March 2016 at 15:21, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> Hello everyone,
>
> I've run into an expected behaviour for a my two disk RAID1.  I mount
> with UUIDs, because sometimes my USB disk gets /dev/sdc instead of
> /dev/sdd.  The two elements of my RAID1 are currently sdb and sdd.
>
> dstat -tdD total,sdb,sdc,sdd
>
> It seems that per process, reads come from either sdb or sdd.  This
> surprises me, because I understood that a btrfs RAID1
