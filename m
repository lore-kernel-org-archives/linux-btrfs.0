From: THomas Schmidt <Schmidt-T@gmx.de>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Tue, 24 Jan 2012 18:15:19 +0100
Message-ID: <6813505.oCLlrdZJVi@exile>
References: <20111117002734.70530@gmx.net> <20111117140625.279050@gmx.net> <4ED740FF.1010304@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED740FF.1010304@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 December 2011 09:55:27 Arne Jansen wrote:
> As RAID0 is already not a strict 'all disks or none', I like the idea to
> have it even more dynamic to reach full optimization. But I'd like to see
> some properties conserved:
>  a) In case of even size disks, the stripes should always be full size, not
>    n - 1
>  b) Minor variations in the used space per disk due to metadata chunks
> should not lead to deviation from a)
>  c) The algorithms should not give weird results under unconventional
> setups. Some theoretical background would be nice :)

Sorry to only get back to you now, I must have missed your mail somehow.

The problem is the shrinking stripe width with unmatched devices. Once it hits devs_min-1 it's over. My solution is to try to keep the stripe width constant.
The sorting then takes care of selecting the right devices.

It's simply: space / min-hight = max-width
a) is dictated by math
Since circumstances change (add, rm devs, rounding, ...) it is calculated again at every allocation. The result is then rounded to the nearest multiple of devs_increment. This takes care of b).

The code may look wiered but should be identical to the mathematical
floor(Space / min-hight + increment/2) if considered together with the round down already present in the line after my patch.

The two ifs should safeguard against weird stuff by limiting the result to sane values.

I include an updated patch below. It's again written for and tested with 3.0.0 but diff3 worked nicely for applying it to 3.3-rc1.

--- volumes.c.orig	2012-01-20 16:59:31.000000000 +0100
+++ volumes.c	2012-01-24 11:24:07.261401805 +0100
@@ -2329,6 +2329,8 @@
 	u64 stripe_size;
 	u64 num_bytes;
 	int ndevs;
+	u64 fs_total_avail;
+	int opt_ndevs;
 	int i;
 	int j;
 
@@ -2448,6 +2450,7 @@
 		devices_info[ndevs].total_avail = total_avail;
 		devices_info[ndevs].dev = device;
 		++ndevs;
+		fs_total_avail += total_avail;
 	}
 
 	/*
@@ -2456,6 +2459,16 @@
 	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
 	     btrfs_cmp_device_info, NULL);
 
+	/*
+	* do not allocate space on all devices
+	* instead balance free space to maximise space utilization
+	*/
+	opt_ndevs = (fs_total_avail*2 + devs_increment*devices_info[0].total_avail) / (devices_info[0].total_avail*2);
+	if (opt_ndevs < devs_min)
+		opt_ndevs = devs_min;
+	if (ndevs > opt_ndevs)
+		ndevs = opt_ndevs;
+
 	/* round down to number of usable stripes */
 	ndevs -= ndevs % devs_increment;

