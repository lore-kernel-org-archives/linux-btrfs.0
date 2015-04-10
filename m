Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33020 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbbDJKka (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 06:40:30 -0400
Date: Fri, 10 Apr 2015 18:40:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: du accuracy
Message-ID: <20150410104015.GB10185@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <201504101125.58088.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201504101125.58088.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 10, 2015 at 11:25:57AM +1000, Russell Coker wrote:
> I'm copying an image of a 2G microSD card to a BTRFS filesystem.  The SD card 
> is from an Android phone and is almost full of Android packages and photos, 
> there's very little space on the filesystem and what space there is probably 
> isn't filled with zeros.
> 
> # ls -l
> total 888000
> -rw-r--r--. 1 root root 1043529728 Apr 10 11:20 2gsd
> 
> While doing it I run ls commands to see the progress and get output like the 
> above.  Why is the file size according to ls not matching the total used?
> 
> # du -h
> 886M    .
> 
> When I ran du immediately afterwards it also reported that there was less than 
> 1G used.
> 
> # du -h
> 1.2G    .
> # du -h
> 1.2G    .
> # du -h
> 1.1G    .
> # du -h
> 1.1G    .
> # du -h
> 1.1G    .
> # du -h
> 1.2G    .
> # du -h
> 1.2G    .
> 
> Above are some consecutive du runs.  Why does the space used go from 1.2G to 
> 1.1G before going up again?  The file was created by "cat /dev/sde > 2gsd" so 
> it definitely wasn't getting smaller.
> 
> What's going on here?

What's your mount options?  with autodefrag or compression?

Thanks,

-liubo
> 
> -- 
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
