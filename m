Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAFPgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 10:36:04 -0500
Date: Mon, 6 Jan 2014 16:36:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Pascal VITOUX <vitoux.pascal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Skip non-regular files in recursive defrag
Message-ID: <20140106153602.GW6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388585425-7051-1-git-send-email-vitoux.pascal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388585425-7051-1-git-send-email-vitoux.pascal@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 01, 2014 at 03:10:25PM +0100, Pascal VITOUX wrote:
> ---
>  cmds-filesystem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 1c1926b..979dbd9 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -646,7 +646,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
>  	int e = 0;
>  	int fd = 0;
>  
> -	if (typeflag == FTW_F) {
> +	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {

The ftw(3) documentation states that FTW_F gets the regular files, do you have a
reproducer whre this does not work as expected?

I think the check could be placed into cmd_defrag, there's a st_mode
check for directories already. Defragmenting makes most sense for
regular files (though there's the option to defrag portions of the
metadata b-trees), so it's fine to handle just directories and regular
files in userspace.

If you're going to resend the patch, please add 'btrfs-progs: ' string
to the subject, write a short changlog and add your Signed-off-by line.

thanks,
david
