Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:57930 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753707AbdIRSan (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 14:30:43 -0400
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1989
To: bo.li.liu@oracle.com, Paul Jones <paul@pauljones.id.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <MEXPR01MB2168C2FE0ABD1B78F120044E9E630@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <00c7d3be-fbff-a911-e7e0-308ebb619e64@applied-asynchrony.com>
Date: Mon, 18 Sep 2017 20:30:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/18/17 19:09, Liu Bo wrote:
> This 'mirror 0' looks fishy, (as mirror comes from
> btrfs_io_bio->mirror_num, which should be at least 1 if raid1 setup is
> in use.)
> 
> Not sure if 4.13.2-gentoo made any changes on btrfs, but can you

No, it did not; Gentoo always strives to be as close to mainline as
possible except for urgent security & low-risk convenience fixes.

-h
