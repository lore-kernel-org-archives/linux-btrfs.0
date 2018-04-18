Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeDRJtg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 05:49:36 -0400
Date: Wed, 18 Apr 2018 11:47:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: add chattr support for send/receive
Message-ID: <20180418094704.GK21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180417233936.30629-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180417233936.30629-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 04:39:35PM -0700, Howard McLauchlan wrote:
> Presently btrfs send/receive does not propagate inode attribute flags;
> all chattr operations are effectively discarded upon transmission.
> 
> This patch adds kernel support for inode attribute flags. Userspace
> support can be found under the commit:
> 
>     btrfs-progs: add chattr support for send/receive
> 
> An associated xfstest can be found at:
> 
>     btrfs: add verify chattr support for send/receive test
> 
> A caveat is that a user with an updated kernel (aware of chattrs) and an
> older version of btrfs-progs (unaware of chattrs) will fail to receive
> if a chattr is included in the send stream.
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>

This is a send protocol change and must be properly versioned. There are
more known defficiencies from v1, see

https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft

> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -77,6 +77,7 @@ enum btrfs_send_cmd {
>  
>  	BTRFS_SEND_C_END,
>  	BTRFS_SEND_C_UPDATE_EXTENT,
> +	BTRFS_SEND_C_CHATTR,
>  	__BTRFS_SEND_C_MAX,

This change

>  };
>  #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
> @@ -114,6 +115,7 @@ enum {
>  	BTRFS_SEND_A_CLONE_PATH,
>  	BTRFS_SEND_A_CLONE_OFFSET,
>  	BTRFS_SEND_A_CLONE_LEN,
> +	BTRFS_SEND_A_CHATTR,
>  
>  	__BTRFS_SEND_A_MAX,

and this will change numbers of __BTRFS_SEND_*_MAX and defines derived
from them, that must stay fixed for v1, because they're part of the
public API exported from progs as send.h.

Unfortunatelly for anybody who wants to implement new additions to the
send stream, the full versioning, backward compatibility, commandline
options, ioctl extensions need to happen first.

A concrete example how this can be done wrong is the Synology version of
btrfs shipped with their NAS. There are some extensions to the protocol
that work on their kernel, but the send stream cannot be used on upstram
kernels.
