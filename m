Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48260 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2FDQPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 12:15:23 -0400
Received: by yhmm54 with SMTP id m54so3040537yhm.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 09:15:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FCCB197.2020709@gmx.net>
References: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
	<4FCCB197.2020709@gmx.net>
Date: Mon, 4 Jun 2012 19:15:22 +0300
Message-ID: <CAHf9xvYTa4f=Qn1zrYNxyhP2fXPWPTW=cAgR_Hoy=3PJFC8_Og@mail.gmail.com>
Subject: Re: inquiry on btrfs send/receive
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, ablock84@googlemail.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Arne,

On Mon, Jun 4, 2012 at 4:01 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 04.06.2012 14:39, Alex Lyakas wrote:
>
>>
>> # How does one track changes in generic INODE_ITEM properties, like
>> "mode" or "uid/gid"? Whenever such property gets changed, INODE_ITEM
>> gets stamped with a new transid, but do we need to compare it with the
>> previous version on the receive side to realize what has changed?
>> # File size - is it required, again, to compare vs previous size, to
>> realize file truncation? (file grow perhaps can be realized via new
>> EXTENT_DATAs)
>
> The basic idea of send/receive is not to find anything that has changed
> since a given transid number, but to find the differences between 2
> snapshots. This way you always have access to the old values.
>
>> # What should be done if INODE_ITEM::flags change (e.g., inode gets
>> nodatacow/nodatasum flags set). What should be done at receive side?
>
>> # How does one track deletion of INODE_ITEMs? Or, deletion and
>> re-creation of a INODE_ITEM with the same inode number? (I saw that
>> inode_cache mount option allows to re-use inode numbers, so I think it
>> can happen.) Does this mean that on receive side, it is required to
>> compare contents of each directory vs previous version?
>
> A recreated inode gets a new inode generation number. That's needed
> for NFS, otherwise NFS could also not detect this case.

So what you are saying is that a tuple (inode number, generation) is
unique within a subvolume. That's a good thing to keep in mind!

>
>> # What should be done with INODE_ITEMs like block/char device, FIFO or a socket?
>
> Everything that can be created on the dest side, like device files,
> should be created.
>
>> # XATTR_ITEMs: although they have a transid stamp, again, need to
>> track deletion/re-creation of them. Again by comparing?
>
> as long as they end up identical on the destination, delete/recreate
> shouldn't matter.
>
> The rest of the question I leave for Jan and Alexander :)
>
> -Arne

Thanks,
Alex.


>
>> # INODE_REFs: these seem most tough to me, because they don't have
>> transid stamps. How such scenario can be handled: an INODE_ITEM had
>> two INODE_REFs with names N1 and N2. But now on the send side, both
>> those INODE_REFs were deleted and INODE_REFs N3 and N4 were created.
>> Does that mean we need to always compare all INODE_REFs for each
>> INODE_ITEM, or we perhaps can use DIR_ITEMs/DIR_INDEXs of parent
>> INODE_ITEM to detect changes in INODE_REFs?
>>
>> All in all, it looks like the approach of navigating the FS tree and
>> trying to *understand* specifically which modifications were
>> performed, is quite error-prone. And I am sure there are modifications
>> I am not aware about.
>>
>> I was wondering, what state your work is in? Is it possible to look at
>> some code or prototype, to understand what approach have you taken, or
>> perhaps an overall description of the approach?
>>
>> Jan, I saw that you provided some new code for backref resolving. Can
>> you give a hint of how is that related to the send/receive
>> functionality?
>>
>> Thanks,
>> Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
