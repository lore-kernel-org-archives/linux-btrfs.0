Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751630AbeDILpp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 07:45:45 -0400
Date: Mon, 9 Apr 2018 13:43:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/16] btrfs: add proper safety check before resuming
 dev-replace
Message-ID: <20180409114313.GK8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <23d9506da78be87309480cd39e884242ef2ff42f.1522780026.git.dsterba@suse.com>
 <2e3e3ca8-a1c4-19c3-6b85-7a4e1d30c6e9@oracle.com>
 <9b0db829-f84f-845d-128d-b12b00b01849@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <9b0db829-f84f-845d-128d-b12b00b01849@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 07, 2018 at 06:43:19PM +0800, Anand Jain wrote:
> On 04/07/2018 02:42 PM, Anand Jain wrote:
> > On 04/04/2018 02:34 AM, David Sterba wrote:
> >> The device replace is paused by unmount or read only remount, and
> >> resumed on next mount or write remount.
> >>
> >> The exclusive status should be checked properly as it's a global
> >> invariant and we must not allow 2 operations run. In this case, the
> >> balance can be also paused and resumed under same conditions. It's
> >> always checked first so dev-replace could see the EXCL_OP already taken,
> >> BUT, the ioctl would never let start both at the same time.
> >>
> >> Replace the WARN_ON with message and return 0, indicating no error as
> >> this is purely theoretical and the user will be informed. Resolving that
> >> manually should be possible by waiting for the other operation to finish
> >> or cancel the paused state.
> > 
> >   So if there is a paused balance and replace is triggered, a write
> >   remount will reverse the process? 
> 
>   Ok, I am answering my own question:
>   Even if the balance is paused that's considered as an exclusive
>   operation in progress and does not let replace to start. So there
>   is no scenario where paused-balance and replace could co-exist.

The code is there to handle a theoretical but possible scenario, when the
balance item and replace items are both on the filesytem image.

>   So an asset will be better insted of return 0.

An assert may not be compile in and we still don't want to let
dev-replace and balance run together. A WARN_ON or BUG in this case is
too intrusive, a human readable error message says what to do, compared
to a stacktrace and insight from somebody else.

> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
> +		btrfs_info(fs_info,
> +		"cannot resume dev-replace, other exclusive operation running");
> +		return 0;
> +	}
