Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50660 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751808AbdIVJQX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 05:16:23 -0400
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
Date: Fri, 22 Sep 2017 17:24:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> +WARNING: Before v4.14 btrfs-progs, *--rootdir* will shrink the filesystem,
> +prevent user to make use of the remaining space.
> +In v4.14 btrfs-progs, this behavior is changed, and will not shrink the fs.
> +The result should be the same as `mkfs`, `mount` and then `cp -r`. +

  Hmm well. Shrink to fit exactly to the size of the given 
files-and-directory is indeed a nice feature. Which would help to create 
a golden-image btrfs seed device. Its not popular as of now, but at some 
point it may in the cloud environment.

  Replacing this feature instead of creating a new option is not a good 
idea indeed. I missed something ?

Thanks, Anand

> +Also, if destination file/block device does not exist, *--rootdir* will not
> +create the image file, to make it follow the normal mkfs behavior.


