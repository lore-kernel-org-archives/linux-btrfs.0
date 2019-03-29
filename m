Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EE7C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 14:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F5E217F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 14:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfC2OJ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:09:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:38056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728652AbfC2OJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 10:09:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F0C47B01C
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 14:09:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B46F5DA882; Fri, 29 Mar 2019 15:11:07 +0100 (CET)
Date:   Fri, 29 Mar 2019 15:11:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v5.3 02/11] btrfs: disk-io: Show the timing of corrupted
 tree block explicitly
Message-ID: <20190329141107.GT29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320062749.30953-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:27:40PM +0800, Qu Wenruo wrote:
> Just add one extra line to show when the corruption is detected.
> Currently only read time detection is possible.
> 
> The planned distinguish line would be:
>   read time:
>     <detail report>
>     block=XXXXX read time tree block corruption detected
> 
>   write time:
>     <detail report>
>     block=XXXXX write time tree block corruption detected
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/disk-io.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6a7a1e168169..e8d4e238f832 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -659,6 +659,10 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  
>  	if (!ret)
>  		set_extent_buffer_uptodate(eb);
> +	else
> +		btrfs_err(fs_info,
> +			  "block=%llu read time tree block corruption detected",

This showed up in test btrfs/124, the logs below do not contain the
selftests outpt, that runs twice, only the last line is kept for
reference. That's the only message from the read/write time checks, the branch
is misc-next.

[ 5432.522317] BTRFS: selftest: running extent_map tests
[ 5432.573684] BTRFS: device fsid 519acff4-bdb4-4459-87b6-8f64ab1360cf devid 1 transid 7 /dev/vdb
[ 5432.578232] BTRFS info (device vdb): allowing degraded mounts
[ 5432.579703] BTRFS info (device vdb): disk space caching is enabled
[ 5432.581348] BTRFS info (device vdb): has skinny extents
[ 5432.583483] BTRFS warning (device vdb): devid 2 uuid dc83669e-dff7-4dee-bcc6-dbef1f470896 is missing
[ 5432.586115] BTRFS warning (device vdb): devid 2 uuid dc83669e-dff7-4dee-bcc6-dbef1f470896 is missing
[ 5513.939435] BTRFS: device fsid af58e3f0-8011-4d2a-b2bd-fc956d458a75 devid 1 transid 238 /dev/vda
[ 5513.992006] BTRFS info (device vdb): disk space caching is enabled
[ 5513.994398] BTRFS info (device vdb): has skinny extents
[ 5514.022526] BTRFS critical (device vdb): corrupt leaf: root=7 block=30474240 slot=0, invalid nritems, have 0 should not be 0 for non-root leaf
[ 5514.028271] BTRFS error (device vdb): block=30474240 read time tree block corruption detected
[ 5514.031529] BTRFS info (device vdb): read error corrected: ino 0 off 30474240 (dev /dev/vdc sector 18560)
[ 5514.034133] BTRFS info (device vdb): read error corrected: ino 0 off 30478336 (dev /dev/vdc sector 18568)
[ 5514.036662] BTRFS info (device vdb): read error corrected: ino 0 off 30482432 (dev /dev/vdc sector 18576)
[ 5514.039784] BTRFS info (device vdb): read error corrected: ino 0 off 30486528 (dev /dev/vdc sector 18584)
[ 5514.042383] BTRFS error (device vdb): bad tree block start, want 32210944 have 651061555542690057
[ 5514.044666] BTRFS info (device vdb): read error corrected: ino 0 off 32210944 (dev /dev/vdc sector 21952)
[ 5514.047146] BTRFS info (device vdb): read error corrected: ino 0 off 32215040 (dev /dev/vdc sector 21960)
[ 5514.049608] BTRFS info (device vdb): read error corrected: ino 0 off 32219136 (dev /dev/vdc sector 21968)
[ 5514.052034] BTRFS info (device vdb): read error corrected: ino 0 off 32223232 (dev /dev/vdc sector 21976)
[ 5514.056223] BTRFS error (device vdb): bad tree block start, want 32276480 have 0
[ 5514.058632] BTRFS info (device vdb): read error corrected: ino 0 off 32276480 (dev /dev/vdc sector 22080)
[ 5514.060448] BTRFS info (device vdb): read error corrected: ino 0 off 32280576 (dev /dev/vdc sector 22088)
[ 5514.064681] BTRFS info (device vdb): balance: start -d -m -s
[ 5514.066309] BTRFS info (device vdb): relocating block group 2479882240 flags data
[ 5514.068870] BTRFS error (device vdb): bad tree block start, want 31539200 have 723401728380766730
[ 5514.087183] BTRFS error (device vdb): bad tree block start, want 31457280 have 578721382704613384
[ 5514.087208] BTRFS error (device vdb): bad tree block start, want 31555584 have 723401728380766730
[ 5514.087244] BTRFS error (device vdb): bad tree block start, want 31522816 have 723401728380766730
[ 5514.107976] BTRFS error (device vdb): bad tree block start, want 31555584 have 723401728380766730
[ 5514.131715] BTRFS error (device vdb): bad tree block start, want 31440896 have 506381209866536711
[ 5514.131739] BTRFS error (device vdb): bad tree block start, want 31457280 have 578721382704613384
[ 5514.155830] BTRFS error (device vdb): bad tree block start, want 31457280 have 578721382704613384
[ 5527.886754] repair_io_failure: 54 callbacks suppressed
[ 5527.886761] BTRFS info (device vdb): read error corrected: ino 0 off 32145408 (dev /dev/vdc sector 21824)
[ 5527.895976] BTRFS info (device vdb): read error corrected: ino 0 off 32149504 (dev /dev/vdc sector 21832)
[ 5527.899446] BTRFS info (device vdb): read error corrected: ino 0 off 32153600 (dev /dev/vdc sector 21840)
