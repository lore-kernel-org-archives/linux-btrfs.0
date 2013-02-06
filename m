Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:64414 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3BFLSg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 06:18:36 -0500
Received: by mail-ia0-f175.google.com with SMTP id r4so1385930iaj.20
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 03:18:36 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 13:18:35 +0200
Message-ID: <CAOcd+r2V_Na-hn10GnV04MqjM=CcdrXTQrWSbKbp6S=mxKaTew@mail.gmail.com>
Subject: Leaking btrfs_qgroup_inherit on snapshot creation?
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Lev Vainblat <lev@zadarastorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan, Arne,
I see this code in create_snapshot:

	if (inherit) {
		pending_snapshot->inherit = *inherit;
		*inherit = NULL;	/* take responsibility to free it */
	}

So, first thing I think it should be:
if (*inherit)
because in btrfs_ioctl_snap_create_v2() we have:
struct btrfs_qgroup_inherit *inherit = NULL;
...
btrfs_ioctl_snap_create_transid(..., &inherit)

so the current check is very unlikely to be NULL.

Second, I don't see anybody freeing pending_snapshot->inherit. I guess
it should be freed after callin btrfs_qgroup_inherit() and also in
btrfs_destroy_pending_snapshots().

Thanks,
Alex.
