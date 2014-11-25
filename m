Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i2.italiaonline.it ([212.48.25.196]:55346 "EHLO
	smtp-17.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864AbaKYHck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 02:32:40 -0500
Message-ID: <54743094.8050200@inwind.it>
Date: Tue, 25 Nov 2014 08:32:36 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: boris <6401e46d@opayq.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: File test operator for subvols; possible bug in 'btrfs show <directory>'
References: <loom.20141125T024507-20@post.gmane.org>
In-Reply-To: <loom.20141125T024507-20@post.gmane.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 03:11 AM, boris wrote:
> Hi all,
> 
> I was looking for a quick method of testing whether a working directory is a 
> subvolume.

Currently btrfs check that:
- the inode number is 255
- the path is a directory

>From cmds-subvolume.c

[...]
/*
 * test if path is a subvolume:
 * this function return
 * 0-> path exists but it is not a subvolume
 * 1-> path exists and it is  a subvolume
 * -1 -> path is unaccessible
 */
int test_issubvolume(char *path)
{
        struct stat     st;
        int             res;

        res = stat(path, &st);
        if(res < 0 )
                return -1;

        return (st.st_ino == 256) && S_ISDIR(st.st_mode);
}
[---]
> 
> Couldn't see an obvious one, so tried 'btrfs show <somesubvol≥'. It printed 
> a fail message as expected but returned 0 exit status. Bug?
> 
> Can I put in a feature request for a shell file test operator for subvols, 
> please (or something of the kind)? http://tldp.org/LDP/abs/html/fto.html . 
> The letter v (for volume, both upper and lower case forms; one for subvol, 
> other for snapshots) is unused afaict. 
> 
> Have I missed the obvious? Or scored a false positive?
> 
> TIA.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
