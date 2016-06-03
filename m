Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbcFCNWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 09:22:19 -0400
Date: Fri, 3 Jun 2016 15:21:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] btrfs-progs: btrfs-crc: fix build error
Message-ID: <20160603132137.GO29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 05:06:37PM +0900, Satoru Takeuchi wrote:
> Remove the following build error.
> 
>    ====================================
>    $ make btrfs-crc
>        [CC]     btrfs-crc.o
>        [LD]     btrfs-crc
>    btrfs-crc.o: In function `usage':
>    /home/sat/src/btrfs-progs/btrfs-crc.c:26: multiple definition of `usage'
>    help.o:/home/sat/src/btrfs-progs/help.c:125: first defined here
>    collect2: error: ld returned 1 exit status
>    Makefile:294: recipe for target 'btrfs-crc' failed
>    make: *** [btrfs-crc] Error 1
>    =====================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

1-5 applied, thanks.
