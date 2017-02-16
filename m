Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:49948 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932944AbdBPSXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 13:23:20 -0500
Reply-To: kreijack@inwind.it
Subject: Re: Device ID issue on btrfs
References: <CAJUuSvG-7jY7vW6KFx5s10vRH2WvB_uDhOhTrP15T4UJFkiPDA@mail.gmail.com>
 <CAJUuSvFkLEsSONM9EwCMS0qJ9eGvtFYXUayFjRcKPE7qRLrVPg@mail.gmail.com>
 <CAJUuSvE=iHHYqjo+QbR3eP92mYdT6NQ8T7Kf--jgC3xniPYj5A@mail.gmail.com>
To: Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <103e47d2-97fc-009a-8e94-a047f2d8b9bd@libero.it>
Date: Thu, 16 Feb 2017 19:23:17 +0100
MIME-Version: 1.0
In-Reply-To: <CAJUuSvE=iHHYqjo+QbR3eP92mYdT6NQ8T7Kf--jgC3xniPYj5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-16 14:00, Ilan Schwarts wrote:
> Hi,
> Found the solution at: https://patchwork.kernel.org/patch/2825842/

The patches below provided by suse seem more general

	http://kernel.opensuse.org/cgit/kernel-source/tree/patches.suse/vfs-add-super_operations-get_inode_dev
	http://kernel.opensuse.org/cgit/kernel-source/tree/patches.suse/btrfs-provide-super_operations-get_inode_dev

Unfortunately is quite invasive

> 
> On Thu, Feb 16, 2017 at 12:05 PM, Ilan Schwarts <ilan84@gmail.com <mailto:ilan84@gmail.com>> wrote:
> 
>     Hi,
> 
>     I hope its ok im reaching to you via mail..
>     I read your message at: _https://marc.info/?l=linux-btrfs&m=148701370108477&w=2 <https://marc.info/?l=linux-btrfs&m=148701370108477&w=2>_
> 
>     I have the same issue in my kernel driver, Did you find an answer ?
> 
>     Thanks
>     -
>     Ilan Schwarts
> 
> 
> 
> 
> -- 
> 
> 
> -
> Ilan Schwarts


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
