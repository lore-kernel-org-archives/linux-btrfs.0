Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:36546 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab3CESnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 13:43:45 -0500
Message-ID: <51363CE6.1010807@sgi.com>
Date: Tue, 5 Mar 2013 12:43:50 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: xfstests <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>,
        <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com>
In-Reply-To: <512DB284.1090806@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch has been committed.

--Rich

commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Thu Feb 28 02:05:56 2013 +0000

     xfstests 276: fix error 'FIBMAP: Invalid argument'

     Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
     checks to the fiemap flags and hence invalid flags are now being
     rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
     that test fails since this commit was added.

     Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x option
     of filefrag, and will fail with
         'FIBMAP: Invalid argument'
     for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
          'FIEMAP failed with unsupported flags 2'
     Remove the '-x' option.

