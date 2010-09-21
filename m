From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: Performance degradation
Date: Mon, 20 Sep 2010 18:19:10 -0700
Message-ID: <D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
References: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain;
	charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dave Cundiff <syshackmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Do you have any kernel processes running constantly?  Any taking near 100% of a CPU?

--rich

On Sep 20, 2010, at 14:24, Dave Cundiff <syshackmin@gmail.com> wrote:

> Hi,
> 
> I have a btrfs backup system that has been running great. Its been
> backing up 6 systems with 500-750 gigs of data using Rsync and
> snapshots. Every night I snapshot the backup and overwrite it.
> Recently it has been unable to complete the backups. Its running soooo
> slow that it can barely finish 1 backup a day. When I first started
> backing up the systems they would all complete in at the most 8 hours.
> I noticed it started happening after I deleted a large number of
> snapshots. This caused the cleaner process to run for a few days.
> After it finished the filesystem has still been to slow to use.
> 
> I'm running kernel 2.6.36-rc4.
> 
> Filesystem was built with -m single -d single and using the compress
> mount option.
> 
> Block device is an Areca RAID5 with 4 Western Digital 2TB drives.
> 
> -- 
> Dave Cundiff
> System Administrator
> A2Hosting, Inc
> http://www.a2hosting.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
