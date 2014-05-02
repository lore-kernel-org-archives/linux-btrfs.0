Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaEBPWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 11:22:05 -0400
Date: Fri, 2 May 2014 17:22:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: send, bump stream version
Message-ID: <20140502152202.GO5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 05:40:48PM +0100, Filipe David Borba Manana wrote:
> This increases the send stream version from version 1 to version 2, adding
> 2 new commands:
> 
> 1) total data size - used to tell the receiver how much file data the stream
>    will add or update;
> 
> 2) fallocate - used to pre-allocate space for files and to punch holes in files.
> 
> This is preparation work for subsequent changes that implement the new features
> (computing total data size and use fallocate for better performance).
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

The changes in the v2/3/4 look good, thanks.  Patches added to next
integratin.
