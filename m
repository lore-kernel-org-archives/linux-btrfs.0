Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbeHTPjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 11:39:35 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180816130515.GR24025@twin.jikos.cz>
References: <20180816130515.GR24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk>
To: dsterba@suse.cz
Cc: dhowells@redhat.com, clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Aug 2018 13:24:07 +0100
Message-ID: <32208.1534767847@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> wrote:

> No it's not. Compression needs the checksums so nodatasum should disable
> compression, which is missing as you found out.

Thanks.

Btw, do fs_info->mount_opt end up inscribed on disk as is?  I don't see
anywhere this obviously happens.

Can I get rid of BTRFS_MOUNT_NOSSD as it would appear to be superfluous with
BTRFS_MOUNT_SSD?

David
