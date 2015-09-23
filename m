Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58205 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbbIWNTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:19:49 -0400
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk> <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk> <20150923131226.GA12815@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5602A6EA.8050107@gmx.com>
Date: Wed, 23 Sep 2015 21:19:38 +0800
MIME-Version: 1.0
In-Reply-To: <20150923131226.GA12815@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月23日 21:12, David Sterba 写道:
> On Tue, Sep 22, 2015 at 02:36:02PM +0000, Hugo Mills wrote:
>>> Yeah, right now there's no persistent default for the allocator. I'm
>>> still hoping that the object properties will magically solve that.
>>
>>     There's no obvious place that filesystem-wide properties can be
>> stored, though. There's a userspace tool to manipulate the few current
>> FS-wide properties, but that's all special-cased to use the
>> "historical" ioctls for those properties, with no generalisation of a
>> property store, or even (IIRC) any external API for them.
>
>  From the UI point, we proposed to add a specifier that would route the
> property to either subvolume or the filesystem:
>
> $ btrfs prop set -t filesystem bgtype raid0
> $ btrfs prop set -t subvolume bgtype raid1
>

BTW, is btrfs going to support different chunk/bg type for subvolume?!
I thought data/meta/system chunk types are all per filesystem level,
and was planning to use superblock to record it...

If really to support that, does it mean we will have different meta/data 
type for each subvolume?
That's a little too flex for me....

Thanks,
Qu

> How this will get stored in the xattrs is another question. As there's
> always only single instance of the filesystem properties, it coud be
> something like 'btrfs.fs.bgtype' and be stored as a xattr of the
> toplevel subvolume.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
