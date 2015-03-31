Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbCaO2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 10:28:07 -0400
Date: Tue, 31 Mar 2015 16:28:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] Btrfs: use BTRFS_COMPRESS_NONE instead of
 0
Message-ID: <20150331142804.GB6821@suse.cz>
Reply-To: dsterba@suse.cz
References: <1427746872-17086-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427746872-17086-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 10:21:11PM +0200, Fabian Frederick wrote:
> cow_file_range_inline() was called with 0 instead of
> actual definition.

Please also fix the initialization in btrfs_finish_ordered_io .
