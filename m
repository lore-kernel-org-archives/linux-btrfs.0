Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46909 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751909AbdFPMe6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 08:34:58 -0400
Date: Fri, 16 Jun 2017 14:33:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, bo.li.liu@oracle.com
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170616123352.GF25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 07, 2017 at 10:43:15AM +0800, Qu Wenruo wrote:
>  fs/btrfs/extent_io.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 122 insertions(+), 2 deletions(-)

I see a lot of warnings from btrfs/094

[13458.628334] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=581632 phys=13078528 len=4096 flags=0x800
[13458.644183] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=864256 phys=13299712 len=4096 flags=0x800
[13458.660097] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=1138688 phys=13504512 len=4096 flags=0x0
[13458.675846] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=1462272 phys=13733888 len=4096 flags=0x800
...

about 1000 in total from a fstest run.
