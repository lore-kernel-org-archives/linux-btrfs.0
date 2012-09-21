Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54206 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab2IUPU5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 11:20:57 -0400
Date: Fri, 21 Sep 2012 17:20:51 +0200
From: David Sterba <dave@jikos.cz>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete
 subvolumes
Message-ID: <20120921152051.GU17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 02:54:08PM +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> With this user will be able to provide more than one subvolume
> to delete.
> eg: btrfs subvolume delete <subvol1> <subvol2>

Yes, this is useful, thanks. I'm thinking if it's ok to stop on
first error, ie. when the subvolume does not exist or is a directory.

david
