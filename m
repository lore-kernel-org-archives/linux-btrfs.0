Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:65062
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751512AbeBOTlV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:41:21 -0500
From: Alex Adriaanse <alex@oseberg.io>
To: Nikolay Borisov <nborisov@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ongoing Btrfs stability issues
Date: Thu, 15 Feb 2018 19:41:19 +0000
Message-ID: <2A1FE868-FE3A-489A-B600-8F460D3DFFC8@oseberg.io>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <83bfc8da-82fd-e2bf-4b27-175bf90ac072@suse.com>
In-Reply-To: <83bfc8da-82fd-e2bf-4b27-175bf90ac072@suse.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Feb 15, 2018, at 12:00 PM, Nikolay Borisov <nborisov@suse.com> wrote:
> 
> So in all of the cases you are hitting some form of premature enospc.
> There was a fix that landed in 4.15 that should have fixed a rather
> long-standing issue with the way metadata reservations are satisfied,
> namely:
> 
> 996478ca9c46 ("btrfs: change how we decide to commit transactions during
> flushing").
> 
> That commit was introduced in 4.14.3 stable kernel. Since you are not
> using upstream kernel I'd advise you check whether the respective commit
> is contained in the kernel versions you are using.
> 
> Other than that in the reports you mentioned there is one crash in
> __del_reloc_root which looks rather interesting, at the very least it
> shouldn't crash...

I checked the Debian source code that's used for building the kernels that we run, and can confirm that both 4.14.7-1~bpo9+1 and 4.14.13-1~bpo9+1 contain the changes associated with the commit you referenced. So crash instances #2, #3, and #4 at https://bugzilla.kernel.org/show_bug.cgi?id=198787 were all running kernels that contain this fix already.

Could it be that some on-disk data structures got (silently) corrupted while we were running pre-4.14.7 kernels, and the aforementioned fix doesn't address anything relating to damage that has already been done? If so, is there a way to detect and/or repair this for existing filesystems other than running a "btrfs check --repair" or rebuilding filesystems (both of which require a significant amount of downtime)?

Thanks,

Alex