Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942319AbcJSOuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:50:23 -0400
Date: Wed, 19 Oct 2016 16:50:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs-progs: send: remove unnecessary code
Message-ID: <20161019145021.GT11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190345.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201610190345.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 12:45:57PM +0900, Tsutomu Itoh wrote:
> Some unnecessary codes are deleted.
> 
>  - the setting of subvol is double.
>  - read only check was already done by previous loop.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
