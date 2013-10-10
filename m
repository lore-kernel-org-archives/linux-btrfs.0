Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3JJDgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Oct 2013 23:36:50 -0400
Message-ID: <52562019.4090508@cn.fujitsu.com>
Date: Thu, 10 Oct 2013 11:33:45 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <20131008164951.GC12986@twin.jikos.cz> <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com> <5256206C.3080306@oracle.com>
In-Reply-To: <5256206C.3080306@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2013 11:35 AM, Anand Jain wrote:
>
>  If 'btrfs_file_extent_item' can contain the ref count it would
>  solve the current problem quite easily.  (problem is that, its
>  of n * n searches to know data extents with its ref for a given
>  subvol).
Just considering btrfs_file_extent_item is not enough, because
we should consider metadata(as i have said before).
>
>  But what'r the challenge(s) to have ref count in the
>  btrfs_file_extent_item ? any thoughts ?
Haven't thought a better idea yet.

>
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

