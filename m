Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58507 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932574AbcHXLyj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 07:54:39 -0400
Date: Wed, 24 Aug 2016 13:53:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix =?utf-8?Q?warning_?=
 =?utf-8?B?InZhcmlhYmxlIOKAmGJsb2Nrc2l6ZeKAmQ==?= set but not used"
Message-ID: <20160824115330.GN16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160823222353.9698-1-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160823222353.9698-1-luis.henriques@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 11:23:53PM +0100, Luis Henriques wrote:
> Variable 'blocksize' in reada_walk_down() is not used since commit
> d3e46fea1b1e ("btrfs: sink blocksize parameter to readahead_tree_block").
> This patch simply removes this variable.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
