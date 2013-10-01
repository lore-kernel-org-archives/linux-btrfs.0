Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3JANZl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 09:25:41 -0400
Date: Tue, 1 Oct 2013 15:25:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: calculate disk space that a subvol could
 free
Message-ID: <20131001132538.GD18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
 <20130927191029.GX30372@lenny.home.zabbo.net>
 <52470F85.6040405@oracle.com>
 <52484105.8090302@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52484105.8090302@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 29, 2013 at 11:02:29PM +0800, Anand Jain wrote:
>  this is to avoid duplicate codes, which indeed spans across
>  most of the search functions that's in there in btrfs-progs.
>  what you suggest is good, but its better to do that collectively.

Good cleanup idea, added to wiki todo list.
