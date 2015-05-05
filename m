Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993444AbbEEPns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 11:43:48 -0400
Date: Tue, 5 May 2015 17:43:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Wolfgang_Mader@brain-frog.de, dsterba@suse.cz
Subject: Re: [PATCH 2/2] Btrfs: check error before reporting missing device
 and add uuid
Message-ID: <20150505154346.GK5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430109979-9397-1-git-send-email-anand.jain@oracle.com>
 <1430109979-9397-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430109979-9397-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 27, 2015 at 12:46:19PM +0800, Anand Jain wrote:
> Report missing device when add is successful,
> otherwise it would exit as ENOMEM. And add uuid
> to the report.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
