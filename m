Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42939 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbdCATY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 14:24:57 -0500
Date: Wed, 1 Mar 2017 16:14:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: docs: fix many typos, plus three edits for
 clarit
Message-ID: <20170301151451.GF4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170221231438.17539-1-nsteeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221231438.17539-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 21, 2017 at 06:14:37PM -0500, Nicholas D Steeves wrote:
> Hi David,
> 
> Please see attached a reasonably thorough patch for all the typos I
> could find in btrfs-progs documentation.  The three edits are very
> minor and look larger than they are because I had to reflow the
> paragraphs.  I'm confident in the quality of the work,

Thank you very much, applied.

> with the
> exception of the following, where I'm not sure what to do:
> 
> Documentation/btrfs-receive.asciidoc
> @@ -66,7 +66,7 @@ tell us where this filesystem is mounted.
>  --dump::
>  dump the stream metadata, one line per operation
>  +
> -Does not require the 'path' parameter. The filesystem chanded.
> +Does not require the 'path' parameter. The filesystem changed.

It should say that the filesystem is not changed, folded to the patch.
