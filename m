Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:43638 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab3BHA3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:29:02 -0500
Date: Fri, 8 Feb 2013 01:28:54 +0100
From: David Sterba <dave@jikos.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130208002854.GA1575@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -144,7 +144,7 @@ struct tree_block {
>  	unsigned int key_ready:1;
>  };
>  
> -#define MAX_EXTENTS 128
> +#define MAX_EXTENTS 512

Is this really related to compression? IIRC I've seen it only in context
of batch work in reloc, but not anywhere near compression. (I may be
wrong of course, just checking).

david
