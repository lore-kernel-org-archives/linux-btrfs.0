Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:52540
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbbCXXJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 19:09:52 -0400
From: "Kline, Matthew" <matthew.kline@flukenetworks.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs balance fails with no space errors (despite having plenty)
Date: Tue, 24 Mar 2015 23:09:47 +0000
Message-ID: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
 <20150325040321.361abf2f@natsu>
In-Reply-To: <20150325040321.361abf2f@natsu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Post your "btrfs fi df" for the filesystem.
>
> In my experience it looks like the conversion may designate large portions of data as "metadata" for whatever reason.
>
> A way to clean this up is to run
>
>  btrfs fi balance start -musage=5 -dusage=5 /path
>
> try repeating this again and again increasing the value gradually from 5 to
> 50-70 in steps of 5 or 10.

Data, single: total=44.00GiB, used=43.37GiB
System, single: total=32.00MiB, used=12.00KiB
Metadata, single: total=2.00GiB, used=876.84MiB
GlobalReserve, single: total=296.00MiB, used=0.00B

Total partition size is 322 GB, as given by `parted -l` (I misspoke in the last email - the drive is only 14% full)

Best,
Matt
