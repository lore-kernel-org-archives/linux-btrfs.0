Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51942 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab3ANSpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:45:32 -0500
Date: Mon, 14 Jan 2013 13:45:29 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 2/2] On a diff-send, avoid sending PREALLOC extent
Message-ID: <20130114184529.GD1876@localhost.localdomain>
References: <CAOcd+r1ZioBQEykibvDdfx-1gmLfUPFfodNK5Dhnv8OB0EFApw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1ZioBQEykibvDdfx-1gmLfUPFfodNK5Dhnv8OB0EFApw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 09, 2013 at 10:41:10AM -0700, Alex Lyakas wrote:
> Subject: [PATCH 2/2] On a diff-send, avoid sending PREALLOC extents, if the
>  parent root has only PREALLOC extents on an appropriate
>  file range.
> 
> This does not fully avoids sending PREALLOC extents, because on full-send or
> new inode we need a new send command to do that. But this patch improves
> the situation by handling diff-sends.
> 
> Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> ---

Malformed patch and it confused patchwork, please resend.  Thanks,

Josef
