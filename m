Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3KMPnb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:43:31 -0500
Date: Wed, 13 Nov 2013 16:43:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs-progs: let get_label return the label instead
 of printing it
Message-ID: <20131113154329.GA18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
 <1384263706-25549-2-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384263706-25549-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 01:41:42PM +0000, Filipe David Borba Manana wrote:
> get_label prints the label at the moment. Change this so that
> the label is returned and printing is done by the caller.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

FYI, I'll add this patch to integration now because it's independent on
the rest of the series.

david
