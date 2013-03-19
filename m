Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47365 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3CSWqL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 18:46:11 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so506571eek.37
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 15:46:09 -0700 (PDT)
From: Marek Otahal <markotahal@gmail.com>
To: Kyle <lists@lolwut.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Date: Tue, 19 Mar 2013 23:46:01 +0100
Message-ID: <1510992.7BWEEWRdZp@beruska>
In-Reply-To: <514759B5.5000507@lolwut.org>
References: <514759B5.5000507@lolwut.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

just reading chattr manpage.. 

On Monday 18 March 2013 14:15:17 you wrote:
> Hi,
> 
> After reading through the btrfs documentation I'm curious to know if 
> it's possible to ever securely erase a file from a btrfs filesystem (or 
> ZFS for that matter). On non-COW filesystems atop regular HDDs one can 
> simply overwrite the file with zeros or random data using dd or some 
> other tool and rest assured that the blocks which contained the 
> sensitive information have been wiped. However on btrfs it would seem 
> any such attempt would write the zeros/random data to a new location, 
> leaving the old blocks with the sensitive data intact. Further, since 
> specifying NOCOW is only possible for newly created files, there seems 
> to be no way to overwrite the appropriate blocks short of deleting the 
> associated file and then filling the entire free filesystem space with 
> zeros/random data such that the old blocks are eventually overwritten. 
> What's the verdict on this?

what would chattr +s do? 

"
When a file with the `s' attribute set is deleted, its blocks are zeroed and written back to the disk.  Note: please make sure to read the bugs and limitations section at the end of this document.
"

Nice spring to all of you! :)
Mark

> 
> Regards,
> 
> Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Marek Otahal :o)
