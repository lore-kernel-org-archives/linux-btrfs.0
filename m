Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728241AbeIJSRj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 14:17:39 -0400
Date: Mon, 10 Sep 2018 15:23:16 +0200
From: David Sterba <dsterba@suse.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: nbdkit as a flexible alternative to loopback mounts
Message-ID: <20180910132316.GR24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtTH-z5u9d6AmommSgC+bESp+Ze4WHMwKueiD+OYpphcqg@mail.gmail.com>
 <20180905143148.GA2680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180905143148.GA2680@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2018 at 03:31:48PM +0100, Richard W.M. Jones wrote:
> On Tue, Sep 04, 2018 at 07:55:00PM -0600, Chris Murphy wrote:
> > https://rwmj.wordpress.com/2018/09/04/nbdkit-as-a-flexible-alternative-to-loopback-mounts/
> > 
> > This is a pretty cool writeup. I can vouch Btrfs will format mount,
> > write to, scrub, and btrfs check works on an 8EiB (virtual) disk.
> >
> > The one thing I thought might cause a problem is the ndb device has a
> > 1KiB sector size, but Btrfs (on x86_64) still uses 4096 byte "sector"
> > and it all seems to work fine despite that.
> 
> Thanks for the kind words.  I did an updated post verifying what you
> said and also noting that the ‘nbd-client -b’ option can be used to
> adjust the sector size:
> 
>   https://rwmj.wordpress.com/2018/09/05/nbdkit-for-loopback-pt-5-8-exabyte-btrfs-filesystem/
> 
> Btrfs still seems to believe the sector size is 4k, although as you
> say it doesn't seem to cause any issues.

The 1k sector is like the hardware sector, eg. 512b or 4k on a HDD. This
is abstracted by block layer and the filesystem accesses the block
device using the bio API, that uses pages and description of offset and
length.  So the sector provided by NBD does not matter here.
