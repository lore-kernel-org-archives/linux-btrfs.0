Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942147AbcJFQAw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 12:00:52 -0400
Date: Thu, 6 Oct 2016 18:00:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: image: fix compiler warning
Message-ID: <20161006160045.GK6576@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610050807.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201610050807.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 05, 2016 at 05:07:48PM +0900, Tsutomu Itoh wrote:
> In v4.8-rc1, gcc 5.3.1 gives following warning. Fixed it.
> 
>     [CC]     btrfs-image.o
> btrfs-image.c: In function 'flush_pending':
> btrfs-image.c:708:17: warning: 'start' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   header->bytenr = cpu_to_le64(start);
>                  ^
> btrfs-image.c:927:6: note: 'start' was declared here
>   u64 start;
>       ^

So the patch makes the compiler warning go away, but is the code
correct? AFAICS, the warning points to the case where flush_pending is
called with done=1 (from create_metadump) and there's zero
md->pending_size . Are you sure this is an expected state and that the
function can proceed with state = 0 ?
