Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:36896 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751185AbdIORhI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:37:08 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: Marat Khalili <mkh@rqc.ru>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <20170914221824.GD7067@carfax.org.uk>
 <15f070ee-ec6a-2140-0908-c43f466505ad@inwind.it>
 <20170915082601.GE7067@carfax.org.uk>
 <7aa8063a-2f1f-c611-d24a-d5e6a9ceb29b@rqc.ru>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <dae5a361-6ff4-c64c-81fa-ed58b1d54dff@inwind.it>
Date: Fri, 15 Sep 2017 19:37:04 +0200
MIME-Version: 1.0
In-Reply-To: <7aa8063a-2f1f-c611-d24a-d5e6a9ceb29b@rqc.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 11:50 AM, Marat Khalili wrote:
> May I state my user's point of view:
> 
> I know one applications that uses O_DIRECT, and it is subtly broken
> on BTRFS. I know no applications that use O_DIRECT and are not
> broken. (Really more statistics would help here, probably some exist
> that provably work.) According to developers making O_DIRECT work on
> BTRFS is difficult if not impossible. Isn't it time to disable
> O_DIRECT like ZFS does AFAIU? Data safety is certainly more important
> than performance gain it may or may not give some applications.

I agree with you, but it should be sufficient to disable O_DIRECT when the file has the checksums. I was unable to observe filesystem corruption when the checksums are disabled.

The use cases where O_DIRECT is useful are VM and databasesM and in these cases also nodatacsum/nodatacow are useful.

BR
G.Baroncelli

> 
> --
> 
> With Best Regards, Marat Khalili
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
