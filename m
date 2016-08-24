Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753142AbcHXL44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 07:56:56 -0400
Date: Wed, 24 Aug 2016 13:55:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Fix =?utf-8?Q?warni?=
 =?utf-8?B?bmcgInZhcmlhYmxlIOKAmGdlbuKAmQ==?= set but not used"
Message-ID: <20160824115542.GO16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160823222323.9613-1-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160823222323.9613-1-luis.henriques@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 11:23:23PM +0100, Luis Henriques wrote:
> Variable 'gen' in reada_for_search() is not used since commit 58dc4ce43251
> ("btrfs: remove unused parameter from readahead_tree_block").  This patch
> simply removes this variable.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
