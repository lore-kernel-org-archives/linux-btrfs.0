Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758366AbaCSBPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 21:15:35 -0400
Message-ID: <5328EEDB.8000202@cn.fujitsu.com>
Date: Wed, 19 Mar 2014 09:11:55 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs-progs: fsck: reduce memory usage of extent
 record struct
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1395144167-775-5-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140318181854.GI29256@twin.jikos.cz>
In-Reply-To: <20140318181854.GI29256@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2014 02:18 AM, David Sterba wrote:
> On Tue, Mar 18, 2014 at 08:02:46PM +0800, Wang Shilong wrote:
>> @@ -2742,7 +2742,10 @@ static int add_extent_rec(struct cache_tree *extent_cache,
>> -	rec->found_rec = extent_rec;
>> +	if (extent_rec)
>> +		rec->found_rec = 1;
>> +	else
>> +		rec->found_rec = 0;
> I've modified this to avoid 'if'
>
> 	rec->found_rec = !!extent_rec;
Dave, thanks for doing this.:-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

