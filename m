Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbeEaL7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 07:59:11 -0400
Date: Thu, 31 May 2018 13:56:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Ting-Chang <tchou@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: restore: fix mistake on overwrite_ok() if
 relative path is given
Message-ID: <20180531115626.GS3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524035535-20385-1-git-send-email-tchou@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524035535-20385-1-git-send-email-tchou@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 03:12:15PM +0800, Ting-Chang wrote:
> From: Ting-Chang Hou <tchou@synology.com>
> 
> fstatat will return -1 with errno EBADF if path_name is relative path.
> This caused an error of the return value of overwrite_ok().
> When restoring the subvolume to destination with relative path,
> it will overwrite the existing file rather than skip it.
> 
> Signed-off-by: tchou <tchou@synology.com>

Applied, thanks.
