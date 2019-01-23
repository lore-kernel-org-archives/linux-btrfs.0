Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BEFC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E17B2184C
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfAWRRO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:17:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:34262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbfAWRRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:17:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 750DAB06F
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:17:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EEE50DA6F5; Wed, 23 Jan 2019 18:16:37 +0100 (CET)
Date:   Wed, 23 Jan 2019 18:16:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
Message-ID: <20190123171635.GU2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118021956.22949-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
> Patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_tree_checker
> Which is based on v5.0-rc1 tag.
> 
> This patchset has the following two features:
> - Tree block validation output enhancement
>   * Output validation failure timing (write time or read time)
>   * Always output tree block level/key mismatch error message
>     This part is already submitted and reviewed.
> 
> - Write time tree block validation check
>   To catch memory corruption either from hardware or kernel.
>   Example output would be:
> 
>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>     BTRFS error (device dm-3): write time tree block corruption detected
>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>     BTRFS error (device dm-3): write time tree block corruption detected
>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
>     BTRFS info (device dm-3): forced readonly
>     BTRFS warning (device dm-3): Skipping commit of aborted transaction.
>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
>     BTRFS info (device dm-3): delayed_refs has NO entry

Two tests complain:

btrfs/139
[ 7064.718943] run fstests btrfs/139 at 2019-01-23 15:56:29
[ 7065.345503] BTRFS info (device vda): disk space caching is enabled
[ 7065.347577] BTRFS info (device vda): has skinny extents
[ 7065.666692] BTRFS: device fsid bc4c99e7-906a-44fd-b797-66eb7c9592d7 devid 1 transid 5 /dev/vdb
[ 7065.684618] BTRFS info (device vdb): disk space caching is enabled
[ 7065.687310] BTRFS info (device vdb): has skinny extents
[ 7065.688887] BTRFS info (device vdb): flagging fs with big metadata feature
[ 7065.693432] BTRFS info (device vdb): checking UUID tree
[ 7065.743019] BTRFS warning (device vdb): qgroup rescan is already in progress
[ 7065.746433] BTRFS info (device vdb): qgroup scan completed (inconsistency flag cleared)
[ 7075.359872] BTRFS critical (device vdb): corrupt leaf: root=7 block=31653888 slot=0, invalid nritems, have 0 should not be 0 for non-root leaf
[ 7075.363155] BTRFS error (device vdb): write time tree block corruption detected
[ 7077.578167] BTRFS: error (device vdb) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
[ 7077.583615] BTRFS info (device vdb): forced readonly
[ 7077.585797] BTRFS warning (device vdb): Skipping commit of aborted transaction.
[ 7077.588813] BTRFS: error (device vdb) in cleanup_transaction:1839: errno=-5 IO failure

generic/344

[11246.567119] run fstests generic/344 at 2019-01-23 17:06:11
[11246.652295] BTRFS info (device vda): disk space caching is enabled
[11246.654434] BTRFS info (device vda): has skinny extents
[11246.730069] BTRFS: device fsid b82bc1cd-b380-4eff-a40a-1924c3bf0580 devid 1 transid 5 /dev/vdb
[11246.740955] BTRFS info (device vdb): disk space caching is enabled
[11246.742694] BTRFS info (device vdb): has skinny extents
[11246.744173] BTRFS info (device vdb): flagging fs with big metadata feature
[11246.772934] BTRFS info (device vdb): checking UUID tree
[11300.857850] BTRFS critical (device vdb): corrupt leaf: root=7 block=31080448 slot=0, invalid nritems, have 0 should not be 0 for non-root leaf
[11300.861739] BTRFS error (device vdb): write time tree block corruption detected
[11300.864232] BTRFS: error (device vdb) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
[11300.867704] BTRFS info (device vdb): forced readonly
[11300.869355] BTRFS warning (device vdb): Skipping commit of aborted transaction.
[11300.871857] BTRFS: error (device vdb) in cleanup_transaction:1839: errno=-5 IO failure
[11300.874292] BTRFS info (device vdb): delayed_refs has NO entry
[11301.261978] BTRFS info (device vdb): disk space caching is enabled
[11301.264639] BTRFS info (device vdb): has skinny extents
[11301.266467] BTRFS info (device vdb): flagging fs with big metadata feature
[11301.299713] BTRFS info (device vdb): checking UUID tree
 [17:07:06]- output mismatch (see /tmp/fstests/results//generic/344.out.bad)
    --- tests/generic/344.out   2018-04-12 16:57:00.652225551 +0000
    +++ /tmp/fstests/results//generic/344.out.bad       2019-01-23 17:07:06.424000000 +0000
    @@ -17,6 +17,7 @@
     INFO: thread 0 created
     INFO: thread 1 created
     INFO: 0 error(s) detected
    +unlink(): Read-only file system

     INFO: zero-filled test...
     INFO: sz = 268435456
    ...
    (Run 'diff -u /tmp/fstests/tests/generic/344.out /tmp/fstests/results//generic/344.out.bad'  to see the entire diff)
