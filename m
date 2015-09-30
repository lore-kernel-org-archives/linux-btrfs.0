Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbbI3Qz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:55:28 -0400
Date: Wed, 30 Sep 2015 18:54:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] using of calloc instead of malloc+memset
Message-ID: <20150930165426.GP11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443459879.git.silvio.fricke@gmail.com>
 <cover.1443546000.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 07:10:35PM +0200, Silvio Fricke wrote:
> Silvio Fricke (11):
>   btrfs-progs: use calloc instead of malloc+memset for btrfs-image.c
>   btrfs-progs: use calloc instead of malloc+memset for btrfs-list.c
>   btrfs-progs: use calloc instead of malloc+memset for chunk-recover.c
>   btrfs-progs: use calloc instead of malloc+memset for cmds-check.c
>   btrfs-progs: use calloc instead of malloc+memset for disk-io.c
>   btrfs-progs: use calloc instead of malloc+memset for extent_io.c
>   btrfs-progs: use calloc instead of malloc+memset for mkfs.c
>   btrfs-progs: use calloc instead of malloc+memset for qgroup.c
>   btrfs-progs: use calloc instead of malloc+memset for quick-test.c
>   btrfs-progs: use calloc instead of malloc+memset for volumes.c
>   btrfs-progs: check: fix memset range

Actually this patch should go first (reordered in git now), then the
semantic rule would apply to it as well and now the malloc/memset patter
is gone.
