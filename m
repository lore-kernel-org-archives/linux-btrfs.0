Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbeIETCR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 15:02:17 -0400
Date: Wed, 5 Sep 2018 15:31:48 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: nbdkit as a flexible alternative to loopback mounts
Message-ID: <20180905143148.GA2680@redhat.com>
References: <CAJCQCtTH-z5u9d6AmommSgC+bESp+Ze4WHMwKueiD+OYpphcqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTH-z5u9d6AmommSgC+bESp+Ze4WHMwKueiD+OYpphcqg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2018 at 07:55:00PM -0600, Chris Murphy wrote:
> https://rwmj.wordpress.com/2018/09/04/nbdkit-as-a-flexible-alternative-to-loopback-mounts/
> 
> This is a pretty cool writeup. I can vouch Btrfs will format mount,
> write to, scrub, and btrfs check works on an 8EiB (virtual) disk.
>
> The one thing I thought might cause a problem is the ndb device has a
> 1KiB sector size, but Btrfs (on x86_64) still uses 4096 byte "sector"
> and it all seems to work fine despite that.

Thanks for the kind words.  I did an updated post verifying what you
said and also noting that the ‘nbd-client -b’ option can be used to
adjust the sector size:

  https://rwmj.wordpress.com/2018/09/05/nbdkit-for-loopback-pt-5-8-exabyte-btrfs-filesystem/

Btrfs still seems to believe the sector size is 4k, although as you
say it doesn't seem to cause any issues.

> Anyway, maybe it's useful for some fstests instead of file backed
> losetup devices?

One interesting feature of nbdkit is that you can write your own
plugins.  For my demonstration, I used the nbdkit-memory-plugin which
implements a purely in-memory sparse array:

  https://github.com/libguestfs/nbdkit/blob/master/plugins/memory/memory.c
  https://github.com/libguestfs/nbdkit/tree/master/common/sparse

But to test btrfs you might want to write a custom plugin.  For
example you might choose a sparse array implementation which is more
suitable for storing specifically btrfs metadata structures, or can
spill to a disk file (which nbdkit-memory-plugin cannot, except swap).

Another thing that's interesting from a testing point of view is the
ability to inject block device errors on demand.  You can either do
this using the supplied nbdkit-error-filter:

  https://rwmj.wordpress.com/2018/09/04/nbdkit-for-loopback-pt-2-injecting-errors/

or if you were writing your own plugin you'd probably want to do it
there.

Anyway hope you find it interesting.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
