Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:35970 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbCMTH6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 15:07:58 -0400
Received: by labgd6 with SMTP id gd6so24630241lab.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 12:07:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H5tFUuWpM98gh=b_NN0F3vZ_69R8Ep1u26Dr7pD2dUBiQ@mail.gmail.com>
References: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
	<20150313123734.GI20767@twin.jikos.cz>
	<CAL3q7H5tFUuWpM98gh=b_NN0F3vZ_69R8Ep1u26Dr7pD2dUBiQ@mail.gmail.com>
Date: Fri, 13 Mar 2015 19:07:56 +0000
Message-ID: <CAL3q7H5KxHoTJGK06fet_pFXTEveJpcwUSmHnXQ7Dxw9Qx-qqg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix comp_oper to get right order
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 6:27 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Fri, Mar 13, 2015 at 12:37 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Fri, Mar 13, 2015 at 02:24:38PM +0800, Liu Bo wrote:
>>> Case (oper1->seq > oper2->seq) should differ with case (oper1->seq < oper2->seq).
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>
>>
>> and should go to stable@ if not to 4.1-rc as it's a bug in the core of
>> qgroups. Waiting for the next merge window would not buy us anything.
>
> Well, unless I missed something, it doesn't seem to cause any real
> harm as the only other search operation on the rbtree uses
> comp_oper_exist(), which totally ignores the seq field.

So that actually makes qgroup_oper_exists() wrong (unrelated to this
patch), which ignores the seq field. In other words it can miss
elements of the tree with the desired bytenr and ref root, since the
second criteria for insertion is the seq value and comp_oper_exist()
only uses bytenr and ref_root for comparing nodes / navigate the tree,
so if the tree has multiple nodes with the same bytenr but different
seqs, it can miss the fact that an operation for the given bytenr and
ref root exists.

>
> Of course it should be fixed anyway as it's logic error likely due to
> copy-paste, but unlikely to fix any real user visible problem.
>
>>
>>> ---
>>> This typo was hiden in a big patch, so we need to work harder on review.
>>
>> Of course, lack of reviews that come from non-maintainers is a perpetual
>> problem. There are never too many and each is highly appreciated.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
