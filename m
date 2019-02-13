Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D2CC282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 07:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EBD9222BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 07:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbfBMHrL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 02:47:11 -0500
Received: from len.romanrm.net ([91.121.75.85]:39504 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732144AbfBMHrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 02:47:11 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 9D9BD20396;
        Wed, 13 Feb 2019 07:47:09 +0000 (UTC)
Date:   Wed, 13 Feb 2019 12:47:08 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
Message-ID: <20190213124708.0dd4dbc4@natsu>
In-Reply-To: <20190212030838.GB9995@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
        <20190212030838.GB9995@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 11 Feb 2019 22:09:02 -0500
Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:

> Still reproducible on 4.20.7.
> 
> The behavior is slightly different on current kernels (4.20.7, 4.14.96)
> which makes the problem a bit more difficult to detect.
> 
> 	# repro-hole-corruption-test
> 	i: 91, status: 0, bytes_deduped: 131072
> 	i: 92, status: 0, bytes_deduped: 131072
> 	i: 93, status: 0, bytes_deduped: 131072
> 	i: 94, status: 0, bytes_deduped: 131072
> 	i: 95, status: 0, bytes_deduped: 131072
> 	i: 96, status: 0, bytes_deduped: 131072
> 	i: 97, status: 0, bytes_deduped: 131072
> 	i: 98, status: 0, bytes_deduped: 131072
> 	i: 99, status: 0, bytes_deduped: 131072
> 	13107200 total bytes deduped in this operation
> 	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> 	94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am

Seems like I can reproduce it as well. Vanilla 4.14.97 with .config loosely
based on Debian's.

$ sudo ./repro-hole-corruption-test 
i: 91, status: 0, bytes_deduped: 131072
i: 92, status: 0, bytes_deduped: 131072
i: 93, status: 0, bytes_deduped: 131072
i: 94, status: 0, bytes_deduped: 131072
i: 95, status: 0, bytes_deduped: 131072
i: 96, status: 0, bytes_deduped: 131072
i: 97, status: 0, bytes_deduped: 131072
i: 98, status: 0, bytes_deduped: 131072
i: 99, status: 0, bytes_deduped: 131072
13107200 total bytes deduped in this operation
am: 4.8 MiB (4964352 bytes) converted to sparse holes.
c5f25fc2b88eaab504a403465658c67f4669261e am
1d9aacd4ee38ab7db46c44e0d74cee163222e105 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am

The above is on a 3TB spinning disk. But on a 512GB NVMe SSD I even got the
same checksums as you did.

$ sudo ./repro-hole-corruption-test 
i: 91, status: 0, bytes_deduped: 131072
i: 92, status: 0, bytes_deduped: 131072
i: 93, status: 0, bytes_deduped: 131072
i: 94, status: 0, bytes_deduped: 131072
i: 95, status: 0, bytes_deduped: 131072
i: 96, status: 0, bytes_deduped: 131072
i: 97, status: 0, bytes_deduped: 131072
i: 98, status: 0, bytes_deduped: 131072
i: 99, status: 0, bytes_deduped: 131072
13107200 total bytes deduped in this operation
am: 4.8 MiB (4964352 bytes) converted to sparse holes.
94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am

In my case both filesystems are not mounted with compression, just chattr +c of
the directory with the script is enough to see the issue.

-- 
With respect,
Roman
