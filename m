Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f199.google.com ([209.85.216.199]:57618 "EHLO
	mail-qc0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaD2Xva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 19:51:30 -0400
Received: by mail-qc0-f199.google.com with SMTP id e16so3042660qcx.10
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:51:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140429222139.GB24298@carfax.org.uk>
References: <CAEm7Kty8sgL850nOPUG3DGmAjJmJZuAPL-EAseRWVD=-i3_RYw@mail.gmail.com>
	<20140429222139.GB24298@carfax.org.uk>
Date: Tue, 29 Apr 2014 16:51:29 -0700
Message-ID: <CAEm7KtxSErdThFQ+coYyYvH7tR1fQB7y3eniR972=kUMSRh-0g@mail.gmail.com>
Subject: Re: EBS volumes with identical UUIDs + btrfs
From: Brandon Philips <brandon@ifup.co>
To: Hugo Mills <hugo@carfax.org.uk>, Brandon Philips <brandon@ifup.co>,
        linux-btrfs@vger.kernel.org, Michael Marineau <mike@marineau.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo-

Thanks for the helpful explanation. This is what I assumed was
happening and it is great to have a clarification. More comments
inline.

On Tue, Apr 29, 2014 at 3:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> The only solution that there is right now is, "don't do that".

This use case, attaching an old block device for recovery or
debugging, is common on a majority of the "cloud" platforms. And
starting from an identical btrfs UUID is common with the prevalence of
the "install, snapshot and replicate the VM" model. So, this leaves us
with two options as I can see:

1. mkfs on first boot of an instance and copy any files over
2. rewrite the UUID on first boot of an instance

> btrfs basically assumes that if several block devices have the same
> UUID in their btrfs superblocks, they're different parts of the same
> filesystem. If they're actually clones of the same filesystem, then it
> has problems, and can _really_ screw things up, as you've discovered.

Best guess: would a mkfs and copy or this tree walk and write be more
expensive? Say I have 40 megabytes of initial data on the btrfs that
would need to be copied in case 1.

Thanks!

Brandon
