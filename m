From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Date: Wed, 22 Dec 2010 12:39:15 -0800
Message-ID: <20101222203915.GA9918@hexapodia.org>
References: <20101220222446.GA8629@hexapodia.org> <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 21, 2010 at 03:07:33AM +0200, Felipe Contreras wrote:
> On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> > I have a directory with 1.2M files in it, which makes readdir very slow
> > on btrfs with cold caches (although it's reasonably fast with hot caches
> > as in the first example below):
> 
> Sounds like:
> 
> Bug 21562 - btrfs is dead slow due to fragmentation
> https://bugzilla.kernel.org/show_bug.cgi?id=21562

Hmmm, how do I look at the btree layout for a given inode?

btrfs-image for this filesystem is 1.7GiB .bz2, so I'm afraid it's not
reasonable to publish it.

-andy
