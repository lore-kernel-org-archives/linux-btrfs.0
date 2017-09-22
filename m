Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56309 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbdIVKjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 06:39:44 -0400
MIME-Version: 1.0
Message-ID: <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
To: "Anand Jain" <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Sep 2017 12:39:27 +0200
In-Reply-To: <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I already stated in an other thread, if you want to shrink, do it in another command line tool.
Do one thing and do it simple. (Although Btrfs itself is already out of the UNIX way)

It may be offline shrink/balance. But not to further complexing the --rootdir option now.

And you also said that, the shrink feature is not a popular feature *NOW*, then I don't think it's worthy to implment it *NOW* either.
Implement future feature in the future please.

And further more, even following the existing shrink behavior, you still need to truncate the file all by yourself.
Which is no better than creating a good sized file and then mkfs on it.

Thanks,
Qu

Sent: Friday, September 22, 2017 at 5:24 PM
From: "Anand Jain" <anand.jain@oracle.com>
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for rootdir option

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


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
