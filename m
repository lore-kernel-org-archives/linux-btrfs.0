From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Deny sys_link across subvolumes.
Date: Fri, 13 Nov 2009 17:15:30 +0800
Message-ID: <3d0408630911130115m37c924act6a36bc78fd12be2@mail.gmail.com>
References: <4AEA7A07.4020006@jp.fujitsu.com> <4AFBB5D2.3060405@jp.fujitsu.com>
	 <20091112150039.GD3196@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091112150039.GD3196@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 11:00 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> On Thu, Nov 12, 2009 at 04:14:26PM +0900, TARUISI Hiroaki wrote:
>>
>> From: Christian Parpart <trapni@gentoo.org>
>>
>> I rebased Christian Parpart's patch to deny hard link across
>> subvolumes. Original patch modifies also btrfs_rename, but
>> I excluded it because we can move across subvolumes now and
>> it make no problem.
>
> Thanks for sending this in again.
>
> Actually, we still can't rename across subvolumes, but we do support
> renaming subvolumes. =A0Do you have some time to add more checks to r=
ename
> as well?
>

Just a note, btrfs_name already has check it.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
