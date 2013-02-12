Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52481 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802Ab3BLQgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 11:36:25 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so125623eaa.31
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 08:36:22 -0800 (PST)
Date: Tue, 12 Feb 2013 18:36:17 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: accept zero for balance usage filter
Message-ID: <20130212163617.GA1922@zambezi.lan>
References: <1360586032-22973-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360586032-22973-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 01:33:52PM +0100, David Sterba wrote:
> The condition can be relaxed to accept also 0 which will delete
> unoccupied chunks and does not need space for the actual data
> relocation. Until there is an automatic empty chunk reclaim, we
> can use this as a last resort option under enospc.
> 
> CC: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>

Josef, please don't pull this one into btrfs-next, it's been deprecated
by "Btrfs: allow for selecting only completely empty chunks" from me.
David and I discussed this on IRC, he is OK with it.

Thanks,

		Ilya
