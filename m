Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdLERhq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 12:37:46 -0500
Date: Tue, 5 Dec 2017 18:35:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use enum instead of constant value
Message-ID: <20171205173546.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512470130-7240-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512470130-7240-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 06:35:30PM +0800, Gu Jinxiang wrote:
> Use enum READA_BACK instead of value 1 to keep source robust.

Are you sure that READA_BACK is the right one? It corresponds to the
value 1, but the actual readahead direction semantics should be
considered. It is not obvious and needs some explanation in the changelog.
