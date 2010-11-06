From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs-progs: add support for mixed data+metadata block
 groups V3
Date: Sat, 6 Nov 2010 16:10:54 -0500
Message-ID: <AANLkTikC+JFSGeb585oO2AdMSBtFqgSPXbHoePmPtDvC@mail.gmail.com>
References: <1288204654-2127-1-git-send-email-josef@redhat.com>
	<20101029012013.68a18b8a.ctpm@ist.utl.pt>
	<20101029010308.GC11684@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101029010308.GC11684@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

My apologies if I missed it, but this looks like the most recent
version of this patch ([PATCH] Btrfs-progs: add support for mixed
data+metadata block groups V3), and this version needs updating to
take into account that BTRFS_FEATURE_INCOMPAT_SPACE_CACHE is no longer
needed.

The kernel btrfs code expects:

#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS    (1ULL << 2)

But this version of the patch gives:

#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS    (1ULL << 3)

with (1ULL << 2) being occupied by the space_cache incompat flag.
