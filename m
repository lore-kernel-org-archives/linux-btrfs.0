Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031386Ab3HIWs5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 18:48:57 -0400
Date: Sat, 10 Aug 2013 00:48:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] btrfs-progs: mark static & remove unused from
 non-kernel code
Message-ID: <20130809224854.GN5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52019C6D.9050308@redhat.com>
 <52019D5F.3070301@redhat.com>
 <52054F1F.5000407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52054F1F.5000407@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 03:20:47PM -0500, Eric Sandeen wrote:
> Mark many functions as static, and remove any resulting dead code.

Thanks.

> -struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
> -			       u64 root_objectid)
> +static struct btrfs_root *
> +link_subvol(struct btrfs_root *root, const char *base, u64 root_objectid)

Please keep the function defintion style if possible. I've fixed that at
commit time, no need to resend.

david
