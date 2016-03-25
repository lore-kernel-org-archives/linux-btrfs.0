Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34541 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcCYNQW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 09:16:22 -0400
Received: by mail-lb0-f170.google.com with SMTP id k12so48408790lbb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 06:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com> <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com> <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com> <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com> <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 25 Mar 2016 14:16:01 +0100
Message-ID: <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
To: Chris Murphy <lists@colorremedies.com>
Cc: Brad Templeton <bradtem@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com> wrote:
> >
> > I am surprised to hear it said that having the mixed sizes is an odd
> > case.
>
> Not odd as in wrong, just uncommon compared to other arrangements being tested.

I think mixed drive sizes in raid1 is a killer feature for a home NAS,
where you replace an old smaller drive with the latest and largest
when you need more storage.

My raid1 currently consists of 6TB+3TB+3*2TB.
