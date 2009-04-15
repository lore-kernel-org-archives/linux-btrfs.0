From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compression performance/scalability
Date: Wed, 15 Apr 2009 10:26:25 -0400
Message-ID: <1239805585.4330.1.camel@think.oraclecorp.com>
References: <e6ac15e50904150644p5f768abdoddbef88c5aff31c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: mp3geek <mp3geek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e6ac15e50904150644p5f768abdoddbef88c5aff31c6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-16 at 01:44 +1200, mp3geek wrote:
> I'm using btrfs (from 2.6.29.1) on my mythtv box, and I've found
> issues recording 2 channels with compression enabled. (2 seperate
> DVB-S cards, recording 2 seperate channels at the same time). One
> recording will be fine, but the other recording will be broken.. file
> is damaged and basically unplayable. Seems better when compression
> isn't enabled when saving 2 streams at the same time, both files
> record fine.. will the performance improve in the upcoming 2.6.30?

This isn't really a performance problem, that sounds like a compression
bug.  I do a bunch of parallel testing on the compression code, and
streaming writes is a pretty simple workload.

So, do you have anything in dmesg about the second file?  Checksum
errors or anything like that?

-chris


