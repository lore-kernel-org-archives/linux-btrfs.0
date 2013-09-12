Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3ILN3z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 09:29:55 -0400
Date: Thu, 12 Sep 2013 15:29:52 +0200
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandra.seetharaman@us.ibm.com
Subject: Re: [PATCH] btrfs-progs: btrfs.8.in: Add info about reverting back
 to root subvolume.
Message-ID: <20130912132952.GB6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2061327.l3bBKU3J9X@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2061327.l3bBKU3J9X@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 11, 2013 at 02:34:05PM +0530, chandan wrote:
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -244,7 +244,8 @@ is similar to \fBsubvolume list\fR command.
>  \fBsubvolume set-default\fR\fI <id> <path>\fR
>  Set the subvolume of the filesystem \fI<path>\fR which is mounted as
>  \fIdefault\fR. The subvolume is identified by \fI<id>\fR, which
> -is returned by the \fBsubvolume list\fR command.
> +is returned by the \fBsubvolume list\fR command. The default subvolume
> +can be set to the root subvolume by passing an \fI<id>\fR value of 5.

The number 5 is an implementation detail, we should recommend to use 0.
