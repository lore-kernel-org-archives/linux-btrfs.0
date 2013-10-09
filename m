Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab3JIIo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 04:44:56 -0400
Message-ID: <5255156E.5010808@cn.fujitsu.com>
Date: Wed, 09 Oct 2013 16:35:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Wang Shilong <wangshilong1991@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <52550DC3.8080807@oracle.com>
In-Reply-To: <52550DC3.8080807@oracle.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/09/2013 04:03 PM, Anand Jain wrote:
> Wang,
>
>
>> 1. First to search inline extent_data
>> 2. Secondly search in extent tree to calculate (extent refs=1)
> but these extents will be of entire fs, how do you filter it for a subvol ?
Sorry, this could not be true as i have expected,(we have to iterate
extent tree with my approach)

If we considered both metadata and data for a subvolume, we just iterate
all the extent items in
the extent tree and add those extents into subvolume's sole size iff:

1> extent ref=1
2> backref root=subvol

However, this also may come very *slowly* when extent tree comes very large.

Thanks,
Wang
>  
>
> Thanks, Anand
>
>> This will avoid n*n rather than n+n which is better¡­
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

