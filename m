Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752360AbdHPOBE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 10:01:04 -0400
Date: Wed, 16 Aug 2017 15:59:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/4] btrfs: convert enum btrfs_compression_type to define
Message-ID: <20170816135941.GE2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170813040244.18841-1-anand.jain@oracle.com>
 <20170813040244.18841-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170813040244.18841-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 12:02:42PM +0800, Anand Jain wrote:
> There isn't a huge list to manage the types, which can be managed
> with defines. It helps to easily print the types in tracing as well.

We use enums in a lot of places, I'd rather keep it as it is.
