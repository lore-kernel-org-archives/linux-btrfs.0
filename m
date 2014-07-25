Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaGYRMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 13:12:37 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6PHCamT013665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 13:12:37 -0400
Date: Fri, 25 Jul 2014 10:12:36 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs.btrfs: round all device sizes to sectorsize
Message-ID: <20140725171236.GJ17798@lenny.home.zabbo.net>
References: <53D1DCB4.8090409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D1DCB4.8090409@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:27:32PM -0500, Eric Sandeen wrote:
> make_btrfs() rounds down the first device size to a multiple of sectorsize:

               ^^^^^^^^^^^

> -	device->total_bytes = block_count;
> +	device->total_bytes = (block_count / sectorsize) * sectorsize;

kerncompat.h:#define round_down(x, y) ((x) & ~__round_mask(x, y))

- z
