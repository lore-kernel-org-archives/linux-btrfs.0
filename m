Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbcBXNUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 08:20:07 -0500
Date: Wed, 24 Feb 2016 14:19:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: update docs for inspect-internal
 dump-super
Message-ID: <20160224131956.GF23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456311154-32703-1-git-send-email-fougner89@gmail.com>
 <1456311154-32703-2-git-send-email-fougner89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456311154-32703-2-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 11:52:34AM +0100, Alexander Fougner wrote:
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -92,6 +92,44 @@ Print info of the specified block only.
>  -t <tree_id>::::
>  Print only the tree with the specified ID.
>  
> +*show-super* [options] <device> [device...]::

The command names are supposed to be in alphabetical order, fixed.
