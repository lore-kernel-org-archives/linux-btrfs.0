Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbcKGPQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 10:16:46 -0500
Date: Mon, 7 Nov 2016 16:16:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: send-test: add checking of clone-src option
Message-ID: <20161107151642.GN12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 05:35:18PM +0900, Tsutomu Itoh wrote:
> +before_size=`ls -l "$here"/send.stream.before | awk '{print $5}'`
> +after_size=`ls -l "$here"/send.stream.after | awk '{print $5}'`

Thanks for the test. Minor fixes: "stat --format=%s" instead of the
above, and /dev/zero instead of urandom and stream redirection so it
works in my NFS setup.
