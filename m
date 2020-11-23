Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244EDC63697
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Nov 2020 17:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F47206B2
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Nov 2020 17:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgKWRsW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 12:48:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:47634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgKWRsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Nov 2020 12:48:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77BCCAD41;
        Mon, 23 Nov 2020 17:48:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 073ADDA818; Mon, 23 Nov 2020 18:46:30 +0100 (CET)
Date:   Mon, 23 Nov 2020 18:46:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v10 11/41] btrfs: implement log-structured superblock for
 ZONED mode
Message-ID: <20201123174630.GK8669@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <cover.1605007036.git.naohiro.aota@wdc.com>
 <5aa30b45e2e29018e19e47181586f3f436759b69.1605007036.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa30b45e2e29018e19e47181586f3f436759b69.1605007036.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 10, 2020 at 08:26:14PM +0900, Naohiro Aota wrote:
> Superblock (and its copies) is the only data structure in btrfs which has a
> fixed location on a device. Since we cannot overwrite in a sequential write
> required zone, we cannot place superblock in the zone. One easy solution is
> limiting superblock and copies to be placed only in conventional zones.
> However, this method has two downsides: one is reduced number of superblock
> copies. The location of the second copy of superblock is 256GB, which is in
> a sequential write required zone on typical devices in the market today.
> So, the number of superblock and copies is limited to be two.  Second
> downside is that we cannot support devices which have no conventional zones
> at all.
> 
> To solve these two problems, we employ superblock log writing. It uses two
> zones as a circular buffer to write updated superblocks. Once the first
> zone is filled up, start writing into the second buffer. Then, when the
> both zones are filled up and before start writing to the first zone again,
> it reset the first zone.
> 
> We can determine the position of the latest superblock by reading write
> pointer information from a device. One corner case is when the both zones
> are full. For this situation, we read out the last superblock of each
> zone, and compare them to determine which zone is older.
> 
> The following zones are reserved as the circular buffer on ZONED btrfs.
> 
> - The primary superblock: zones 0 and 1
> - The first copy: zones 16 and 17
> - The second copy: zones 1024 or zone at 256GB which is minimum, and next
>   to it

I was thinking about that, again. We need a specification. The above is
too vague.

- supported zone sizes
  eg. if device has 256M, how does it work? I think we can support
  zones from some range (256M-1G), where filling the zone will start
  filing the other zone, leaving the remaining space empty if needed,
  effectively reserving the logical range [0..2G] for superblock

- related to the above, is it necessary to fill the whole zone?
  if both zones are filled, assuming 1G zone size, do we really expect
  the user to wait until 2G of data are read?
  with average reading speed 150MB/s, reading 2G will take about 13
  seconds, just to find the latest copy of the superblock(!)

- what are exact offsets of the superblocks
  primary (64K), ie. not from the beginning
  as partitioning is not supported, nor bootloaders, we don't need to
  worry about overwriting them

- what is an application supposed to do when there's a garbage after a
  sequence of valid superblocks (all zeros can be considered a valid
  termination block)

The idea is to provide enough information for a 3rd party tool to read
the superblock (blkid, progs) and decouple the format from current
hardware capabilities. If the zones are going to be large in the future
we might consider allowing further flexibility, or fix the current zone
maximum to 1G and in the future add a separate incompat bit that would
extend the maximum to say 10G.
