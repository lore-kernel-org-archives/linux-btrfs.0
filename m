Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaETQge (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:36:34 -0400
Date: Tue, 20 May 2014 18:36:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] btrfs: usage error should not be logged into
 system log
Message-ID: <20140520163633.GM31608@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400519071-5580-2-git-send-email-anand.jain@oracle.com>
 <1400567891-9571-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400567891-9571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 02:38:11PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> I have an opinion that system logs /var/log/messages are
> valuable info to investigate the real system issues at
> the data center. People handling data center issues
> do spend a lot time and efforts analyzing messages
> files. Having usage error logged into /var/log/messages
> is something we should avoid.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

In this case the source of the error is only one and the label
constraints are simple, so the syslog message does not add much.
