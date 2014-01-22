Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbaAVLbM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 06:31:12 -0500
Date: Wed, 22 Jan 2014 12:31:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix snprintf usage by send's gen_unique_name
Message-ID: <20140122113111.GD6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390347398-6490-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390347398-6490-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:36:38PM +0000, Filipe David Borba Manana wrote:
> The buffer size argument passed to snprintf must account for the
> trailing null byte added by snprintf, and it returns a value >= then
> sizeof(buffer) when the string can't fit in the buffer.
> 
> Since our buffer has a size of 64 characters, and the maximum orphan
> name we can generate is 63 characters wide, we must pass 64 as the
> buffer size to snprintf, and not 63.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

JFYI, I have a patch to do the same plus cleans the code around, but
it's part of a bigger series that's in testing atm, so I haven't sent it
yet.

Consider it
Reviewed-by: David Sterba <dsterba@suse.cz>

I'll update my version.
