Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36607 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2IBFoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Sep 2012 01:44:17 -0400
Date: Sun, 2 Sep 2012 07:44:10 +0200
From: David Sterba <dave@jikos.cz>
To: Shentino <shentino@gmail.com>
Cc: Michael <mike@draftx.net>, cwillu <cwillu@cwillu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: rfc: fuzz testing by direct writes to device
Message-ID: <20120902054410.GG17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
 <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
 <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
 <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
 <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
 <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
 <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 01, 2012 at 06:03:32PM -0700, Shentino wrote:
> This whole subject was also about using sed to corrupt-o-magic a
> file's data on disk.
> 
> Is this an acceptable method for testing?

Starting with kernels 3.4 the error handling has been improved,
namely for the EIO, so it shouldn't take your box down when you hit one.
Newer kernels got fixes to the 'transaction abort' cleanup, so it should
be possible to umount and mount the filesystem without problems.

The filesystem should survive shooting at blocks, the checksums catch
any change (with respect to it's strength, ie. generating a hash
collision will lead to crash/abort later).

Expected result for reading blocks after random writes is:
* EIO for the corrupted block (both data or metadata) provided that
  there's no other copy
* transparent and automatic repair from other copies

I've tested this on an 2 disk data/raid1, metadata/raid1 with a running
dd over one of the devices continually and using the filesystem. It was
slower.


david
