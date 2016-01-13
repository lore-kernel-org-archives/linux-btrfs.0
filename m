Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2894 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752905AbcAMAhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 19:37:31 -0500
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
To: <kreijack@inwind.it>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160112142806.GL4227@twin.jikos.cz> <56955A2A.6070708@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56959C2D.6000307@cn.fujitsu.com>
Date: Wed, 13 Jan 2016 08:37:01 +0800
MIME-Version: 1.0
In-Reply-To: <56955A2A.6070708@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Goffredo Baroncelli wrote on 2016/01/12 20:55 +0100:
> On 2016-01-12 15:28, David Sterba wrote:
> [...]
>> How about this:
>>
>> - keep the global reserve in the output, separate from metadata and not
>>     accounted
>> - add new option to account the global reserve into metadata and then
>>     drop it from the output
>
>
> Instead of dropping it, what about prefixing it with '\_' in order to show that
> it is a subtype of metadata (it is not a my idea, I read this sometime ago in
> this mailing list) ?
>
> $ btrfs fi df /
> Data, single: total=29.00GiB, used=21.01GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=2.00GiB, used=716.59MiB
> \_GlobalReserve, single: total=240.00MiB, used=0.00B

Yes, that's what my new patch does:

See the code:
+			printf(" \\- %s: reserved=%s, used=%s\n",
+				btrfs_group_type_str(sp->flags),
+				pretty_size_mode(sp->total_bytes, unit_mode),
+				pretty_size_mode(sp->used_bytes, unit_mode));

Although I'm using "\-" other than "\_".

Thanks,
Qu

>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>


