Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42213 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbbCMS1d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 14:27:33 -0400
Received: by lbjb6 with SMTP id b6so24514691lbj.9
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 11:27:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150313123734.GI20767@twin.jikos.cz>
References: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
	<20150313123734.GI20767@twin.jikos.cz>
Date: Fri, 13 Mar 2015 18:27:31 +0000
Message-ID: <CAL3q7H5tFUuWpM98gh=b_NN0F3vZ_69R8Ep1u26Dr7pD2dUBiQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix comp_oper to get right order
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 12:37 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Mar 13, 2015 at 02:24:38PM +0800, Liu Bo wrote:
>> Case (oper1->seq > oper2->seq) should differ with case (oper1->seq < oper2->seq).
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

>
> and should go to stable@ if not to 4.1-rc as it's a bug in the core of
> qgroups. Waiting for the next merge window would not buy us anything.

Well, unless I missed something, it doesn't seem to cause any real
harm as the only other search operation on the rbtree uses
comp_oper_exist(), which totally ignores the seq field.

Of course it should be fixed anyway as it's logic error likely due to
copy-paste, but unlikely to fix any real user visible problem.

>
>> ---
>> This typo was hiden in a big patch, so we need to work harder on review.
>
> Of course, lack of reviews that come from non-maintainers is a perpetual
> problem. There are never too many and each is highly appreciated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
