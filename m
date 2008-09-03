From: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
Date: Wed, 3 Sep 2008 11:03:55 -0400
Message-ID: <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
References: <48f7fe350809030752s329a0d09y27530d22237c57ba@mail.gmail.com>
	 <200809031700.47477.toei.rei@stargazer.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Toei Rei" <toei.rei@stargazer.at>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755774AbYICPEH@vger.kernel.org>
In-Reply-To: <200809031700.47477.toei.rei@stargazer.at>
List-ID: <linux-btrfs.vger.kernel.org>

I dont think that is the case, the compressed reiser4 partition only
had 1.6gig of data, uncompressed on my ext3 partition is about 2.2
gig. The btrfs image I made was 3gig so I dont think it ran out of
space.

-Ryan

On Wed, Sep 3, 2008 at 11:00 AM, Toei Rei <toei.rei@stargazer.at> wrote:
> Hi Ryan,
>
> I'm not sure, but if you'd ask me, this looks like the btrfs partition is
> full. Btrfs cannot handle the disc full event yet!
>
> Rei
>
