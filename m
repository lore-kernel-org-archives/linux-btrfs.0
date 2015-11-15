Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35252 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbbKOD1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 22:27:01 -0500
Received: by wmdw130 with SMTP id w130so72290310wmd.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 19:27:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
Date: Sun, 15 Nov 2015 05:27:00 +0200
Message-ID: <CA+LE0jyvd8f=z8GR7V2=cLzV3Khfn1YpEHka5-6k0JiSPa5-+Q@mail.gmail.com>
Subject: Re: Using Btrfs on single drives
From: audio muze <audiomuze@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: audio muze <audiomuze@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've gone ahead and created a single drive Btrfs filesystem on a 3TB
drive and started copying content from a raid5 array to the Btrfs
volume.  Initially copy speeds were very good sustained at ~145MB/s
and I left it to run overnight.  This morning I ran btrfs fi usage
/mnt/btrfs and it reported around 700GB free.  I selected another
folder containing 204GB and started a copy operation, again from the
raid5 array to the Btrfs volume.  Copying is now materially slower and
slowing further...it started at ~105MB/s and after 141GB has slowed to
around 97MB/s.  Is this to be expected with Btrfs of have I come
across a bug of some sort?

On Sat, Nov 14, 2015 at 12:43 PM, audio muze <audiomuze@gmail.com> wrote:
> I'm looking to make a "production copy" of my music and video library
> for use in our media server.  It is not my intent to create any form
> of RAID array, but rather to treat each drive independently where
> filesystem is concerned and then to create a single view of the drives
> using mhddfs.  As the data will remain relatively static I may also
> deploy Snapraid in conjunction with mhddfs.
>
> I'm considering using Btrfs as the underlying filesystem on each of
> the individual drives, principally to take advantage of metadata
> redundancy.  Am I corect in surmising that ?I can turn checksumming
> off given it's of no utility where a Btrfs volume is comprised of a
> single device only?
