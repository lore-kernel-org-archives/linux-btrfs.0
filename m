Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62233 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1K2VAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Nov 2011 16:00:42 -0500
Received: by vcbfk14 with SMTP id fk14so5063009vcb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2011 13:00:41 -0800 (PST)
MIME-Version: 1.0
Reply-To: chb@muc.de
In-Reply-To: <f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
Date: Tue, 29 Nov 2011 22:00:40 +0100
Message-ID: <CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
From: Christian Brunner <chb@muc.de>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/28 Alexandre Oliva <oliva@lsd.ic.unicamp.br>:
> We're failing to create clusters with bitmaps because
> setup_cluster_no_bitmap checks that the list is empty before inserting
> the bitmap entry in the list for setup_cluster_bitmap, but the list
> field is only initialized when it is restored from the on-disk free
> space cache, or when it is written out to disk.
>
> Besides a potential race condition due to the multiple use of the list
> field, filesystem performance severely degrades over time: as we use
> up all non-bitmap free extents, the try-to-set-up-cluster dance is
> done at every metadata block allocation.  For every block group, we
> fail to set up a cluster, and after failing on them all up to twice,
> we fall back to the much slower unclustered allocation.

This matches exactly what I've been observing in our ceph cluster.
I've now installed your patches (1-11) on two servers.
The cluster setup problem seems to be gone. - A big thanks for that!

However another thing is causing me some headeache:

When I'm doing havy reading in our ceph cluster. The load and wait-io
on the patched servers is higher than on the unpatched ones.

Dstat from an unpatched server:

----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
  1   6  83   8   0   1|  22M  348k| 336k   93M|   0     0 |8445  3715
  1   5  87   7   0   1|  12M 1808k| 214k   65M|   0     0 |5461  1710
  1   3  85  10   0   0|  11M  640k| 313k   49M|   0     0 |5919  2853
  1   6  84   9   0   1|  12M  608k| 358k   69M|   0     0 |7406  3645
  1   7  78  13   0   1|  15M 5344k| 348k  105M|   0     0 |9765  4403
  1   7  80  10   0   1|  22M 1368k| 358k   89M|   0     0 |8036  3202
  1   9  72  16   0   1|  22M 2424k| 646k  137M|   0     0 |  12k 5527

Dstat from a patched server:

---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
  1   2  61  35   0   0|2500k 2736k| 141k   34M|   0     0 |4415  1603
  1   4  48  47   0   1|  10M 3924k| 353k   61M|   0     0 |6871  3771
  1   5  55  38   0   1|  10M 1728k| 385k   92M|   0     0 |8030  2617
  2   8  69  20   0   1|  18M 1384k| 435k  130M|   0     0 |  10k 4493
  1   5  85   8   0   1|7664k   84k| 287k   97M|   0     0 |6231  1357
  1   3  91   5   0   0|  10M  144k| 194k   44M|   0     0 |3807  1081
  1   7  66  25   0   1|  20M 1248k| 404k  101M|   0     0 |8676  3632
  0   3  38  58   0   0|8104k 2660k| 176k   40M|   0     0 |4841  2093


This seems to be coming from "btrfs-endio-1". A kernel thread that has
not caught my attention on unpatched systems, yet.

I did some tracing on that process with ftrace and I can see that the
time is wasted in end_bio_extent_readpage(). In a single call to
end_bio_extent_readpage()the functions unlock_extent_cached(),
unlock_page() and btrfs_readpage_end_io_hook() are invoked 128 times
(each).

Do you have any idea what's going on here?

(Please note that the filesystem is still unmodified - metadata
overhead is large).

Thanks,
Christian
