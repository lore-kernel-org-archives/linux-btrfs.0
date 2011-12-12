From: Christian Brunner <chb@muc.de>
Subject: Re: avoid redundant block group free-space checks
Date: Mon, 12 Dec 2011 21:32:04 +0100
Message-ID: <CAO47_-_wfpYR_rNZY2S14LYMCm+EyDSJXtJDZrNBoUiyncLGrg@mail.gmail.com>
References: <ory5uite4g.fsf@livre.localdomain>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ory5uite4g.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/12 Alexandre Oliva <oliva@lsd.ic.unicamp.br>:
> It was pointed out to me that the test for enough free space in a block
> group was wrong in that it would skip a block group that had most of its
> free space reserved by a cluster.
>
> I offer two mutually exclusive, (so far) very lightly tested patches to
> address this problem.
>
> One moves the test to the middle of the clustered allocation logic,
> between the release of the cluster and the attempt to create a new
> cluster, with some ugliness due to more indentation, locking operations
> and testing.
>
> The other, that I like better but haven't given any significant amount
> of testing yet, only performs the test when we fall back to unclustered
> allocation, relying on btrfs_find_space_cluster to test for enough free
> space early (it does); it also arranges for the cluster in the current
> block group to be released before we try unclustered allocation.

I've chosen to try the second patch in our ceph environment. It seems
that btrfs_find_space_cluster() isn't called any longer.
find_free_extent() is much faster now.

(I think that the write-io numbers are still to high, though.)

Thanks,
Christian
