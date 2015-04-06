Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbDFI6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 04:58:06 -0400
Date: Mon, 6 Apr 2015 09:58:02 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Chris Mason <clm@fb.com>
Cc: stable <stable@vger.kernel.org>, Btrfs <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please add 9c4f61f01d269815bb7c37be3ede59c5587747c6 to stable
Message-ID: <20150406085802.GA29053@charon.olymp>
References: <1427984267.10670.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1427984267.10670.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 10:17:47AM -0400, Chris Mason wrote:
> Hi stable friends,
> 
> Can you please backport this one to 3.19.y.  It fixes a bug introduced by:
> 
> 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable 3.14+
> 
> The symptoms of the bug are deadlocks during log reply after a crash.  The
> patch wasn't intentionally fixing the deadlock, which is why we missed it
> when tagging fixes.
> 
> Please put this commit everywhere you've cherry-picked
> 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756
> 

Thank you, I'll queue this fix for the 3.16 kernel.

Cheers,
--
Luís

> commit 9c4f61f01d269815bb7c37be3ede59c5587747c6
> Author: David Sterba <dsterba@suse.cz>
> Date:   Fri Jan 2 19:12:57 2015 +0100
> 
>    btrfs: simplify insert_orphan_item
> 
>    We can search and add the orphan item in one go,
>    btrfs_insert_orphan_item will find out if the item already exists.
> 
>    Signed-off-by: David Sterba <dsterba@suse.cz>
> 
> -chris
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

