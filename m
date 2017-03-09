Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932279AbdCIMVe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 07:21:34 -0500
Date: Thu, 9 Mar 2017 13:20:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: consistent usage of types in balance_args
Message-ID: <20170309122056.GB14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170308175843.4502-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170308175843.4502-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 06:58:43PM +0100, Hans van Kranenburg wrote:
> The btrfs_balance_args are only used for the balance ioctl, so use __u
> instead of __le here for consistency. The __le usage was introduced in
> bc3094673f22d and dee32d0ac3719 and was probably a result of
> copy/pasting when the code was written.
> 
> The usage of __le did not break anything, but it's unnecessary. Also,
> this change makes the code less confusing for the careful reader.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Reviewed-by: David Sterba <dsterba@suse.com>
