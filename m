Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbaGVRrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 13:47:06 -0400
Date: Tue, 22 Jul 2014 19:47:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: syslog when quota is enabled
Message-ID: <20140722174704.GD1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 08, 2014 at 02:41:28AM +0800, Anand Jain wrote:
> must syslog when btrfs working config changes so is to support
> offline investigation of the issues.

Missing Signed-off-by line

Reviewed-by: David Sterba <dsterba@suse.cz>
