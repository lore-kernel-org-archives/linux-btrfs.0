Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:57176 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaL2VQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 16:16:48 -0500
Received: by mail-yh0-f51.google.com with SMTP id a41so6901887yho.10
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 13:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
Date: Mon, 29 Dec 2014 14:16:47 -0700
Message-ID: <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: Chris Murphy <lists@colorremedies.com>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 29, 2014 at 12:00 PM, sys.syphus <syssyphus@gmail.com> wrote:
> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
> speak raid10 means you can lose 2 drives assuming they aren't the
> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
> one no matter what?

It's only for sure one in any case even with conventional raid10. It
just depends on which 2 you lose that depends whether your data has
dodged a bullet. Obviously you can't lose a drive and its mirror,
ever, or the array collapses.

-- 
Chris Murphy
