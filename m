Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaCLMdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 08:33:51 -0400
Date: Wed, 12 Mar 2014 13:33:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Guangyu Sun <guangyu.sun@oracle.com>
Cc: linux-btrfs@vger.kernel.org, koen.de.wit@oracle.com
Subject: Re: [PATCH v2] Btrfs: return EPERM when deleting a default subvolume
Message-ID: <20140312123349.GY7004@suse.cz>
Reply-To: dsterba@suse.cz
References: <1394562258-17024-1-git-send-email-guangyu.sun@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394562258-17024-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 11, 2014 at 11:24:18AM -0700, Guangyu Sun wrote:
> The error message is confusing:
> 
>  # btrfs sub delete /mnt/mysub/
>  Delete subvolume '/mnt/mysub'
>  ERROR: cannot delete '/mnt/mysub' - Directory not empty
> 
> The error message does not make sense to me: It's not about deleting a
> directory but it's a subvolume, and it doesn't matter if the subvolume is
> empty or not.
> 
> Maybe EPERM or is more appropriate in this case, combined with an explanatory
> kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
> it is configured as default subvolume.")
> 
> Reported-by: Koen De Wit <koen.de.wit@oracle.com>
> Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
