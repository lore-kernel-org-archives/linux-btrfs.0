From: Josef Bacik <jbacik@redhat.com>
Subject: Re: kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
Date: Wed, 3 Sep 2008 11:03:04 -0400
Message-ID: <20080903150304.GA31775@unused.rdu.redhat.com>
References: <48f7fe350809030752s329a0d09y27530d22237c57ba@mail.gmail.com> <200809031700.47477.toei.rei@stargazer.at> <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toei Rei <toei.rei@stargazer.at>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Ryan Hope <rmh3093@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 03, 2008 at 11:03:55AM -0400, Ryan Hope wrote:
> I dont think that is the case, the compressed reiser4 partition only
> had 1.6gig of data, uncompressed on my ext3 partition is about 2.2
> gig. The btrfs image I made was 3gig so I dont think it ran out of
> space.
>

Yeah you ran out of space.  There are a few weird things about the allocator, so
once you start getting to about 60% full you run the chance of not being able to
allocate more chunks, and therefore run the risk of not being able to allocate
space for something and then trip one of the millions of BUG()'s that are
sitting around to trap those cases.  Hopefully 0.16 will be a little less pissy
about this.

Josef 
