From: David Sterba <dave@jikos.cz>
Subject: Re: Minimum device size of 256 MiB?
Date: Mon, 14 May 2012 13:19:09 +0200
Message-ID: <20120514111909.GG25501@twin.jikos.cz>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Berke Durak <berke.durak@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2012 at 03:57:24PM -0400, Berke Durak wrote:
> There seems to be a 256 MiB lower limit on device size : mkfs.btrfs
> refuses to create a filesystem
> on a device that is smaller than that.

I was experimenting with the mkfs and sizes, and I found that:

* mkfs crashes for sizes < 4M
* mkfs sizes 4-10M is ok, mount passes, but the fs is unwritable and
  reports 'no space left', this is due to some hardcoded numbers in the
  allocator paths
* mkfs 11M+ ok, mount ok, fs is writable and an exhaustive write filled
  the fs to SIZE-4M of data

> What are the structural reasons for this limit?  Could I reduce this
> limit easily with a couple small code changes
> or would it take a major effort?

It should be possible to push the limit downwards, to like 2MB (current
allocation 'cluster' size), or even to 1.44 so btrfs can support floppy
disks as well. It's not a major work, but one has to make sure not to
break assumptions made on various levels through the allocator(s).


david
