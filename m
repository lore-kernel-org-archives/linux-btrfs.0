Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab3CNXSk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 19:18:40 -0400
Date: Fri, 15 Mar 2013 00:18:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, peter@stuge.se
Subject: Re: [PATCH 05/10] restore: Split output directory and btrfs-local
 path search_dir() parameters
Message-ID: <20130314231839.GZ7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-6-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363109897-7931-6-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 01:38:12PM -0400, Josef Bacik wrote:
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -39,6 +39,7 @@
>  #include "utils.h"
>  #include "commands.h"
>  
> +static char fs_name[4096];

Path handling should use PATH_MAX, but I'm ok with a separate patch to
fix all of them in one go.

>  static char path_name[4096];

david
