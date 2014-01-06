Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl.turmel.org ([74.117.157.138]:57036 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbaAFRRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 12:17:42 -0500
Message-ID: <52CAE18B.8020701@turmel.org>
Date: Mon, 06 Jan 2014 12:02:03 -0500
From: Phil Turmel <philip@turmel.org>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>, neilb@suse.de
CC: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2014 04:31 AM, Andrea Mazzoleni wrote:
> Hi,
> 
> This is a port to the Linux kernel of a RAID engine that I'm currently using
> in a hobby project called SnapRAID. This engine supports up to six parities
> levels and at the same time maintains compatibility with the existing Linux
> RAID6 one.

FWIW, your patch 1/2 doesn't seem to have gone through on linux-raid,
although I saw it on lkml.  Probably a different file size limit, as
that's a very large patch.

You might want to break the next submission into smaller parts.  That
might help people review it, too.

Thanks for doing this work!

Phil
