Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaEZRlm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 13:41:42 -0400
Date: Mon, 26 May 2014 19:41:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, sandeen@redhat.com,
        rm@romanrm.net, koen@dominion.thruhere.net
Subject: Re: [PATCH 1/2 v4] btrfs: label should not contain return char
Message-ID: <20140526174140.GI5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
 <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 23, 2014 at 10:50:01AM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> generally if you use
>   echo "test" > /sys/fs/btrfs/<fsid>/label
> it would introduce return char at the end and it can not
> be part of the label. The correct command is
>   echo -n "test" > /sys/fs/btrfs/<fsid>/label
> 
> This patch will check for this user error
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Thanks.
