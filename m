Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:52901 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbeHRXy4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Aug 2018 19:54:56 -0400
Reply-To: waxhead@dirtcellar.net
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: Adam Hunt <voxadam@gmail.com>, linux-btrfs@vger.kernel.org
References: <ompef3$sim$1@blaine.gmane.org>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
Date: Sat, 18 Aug 2018 22:45:56 +0200
MIME-Version: 1.0
In-Reply-To: <ompef3$sim$1@blaine.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Hunt wrote:
> Back in 2014 Ted Tso introduced the lazytime mount option for ext4 and
> shortly thereafter a more generic VFS implementation which was then
> merged into mainline. His early patches included support for Btrfs but
> those changes were removed prior to the feature being merged. His
> changelog includes the following note about the removal:
> 
>    - Per Christoph's suggestion, drop support for btrfs and xfs for now,
>      issues with how btrfs and xfs handle dirty inode tracking.  We can add
>      btrfs and xfs support back later or at the end of this series if we
>      want to revisit this decision.
> 
> My reading of the current mainline shows that Btrfs still lacks any
> support for lazytime. Has any thought been given to adding support for
> lazytime to Btrfs?
> 
> Thanks,
> 
> Adam
> 

Is there any new regarding this?
