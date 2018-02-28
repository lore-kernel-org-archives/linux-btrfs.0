Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:44017 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbeB1Sgu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 13:36:50 -0500
Received: by mail-vk0-f67.google.com with SMTP id p189so2088661vkd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 10:36:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180228175013.GG27791@twin.jikos.cz>
References: <1519836220.1693.23.camel@gmail.com> <20180228175013.GG27791@twin.jikos.cz>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 28 Feb 2018 18:36:48 +0000
Message-ID: <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
Subject: Re: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
To: dsterba@suse.cz, peteryuchuang@gmail.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 28, 2018 at 5:50 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Feb 28, 2018 at 05:43:40PM +0100, peteryuchuang@gmail.com wrote:
>> On my laptop, which has just been switched to BTRFS, the root partition
>> (a BTRFS partition inside an encrypted LVM. The drive is an NVMe) is
>> re-mounted as read-only few minutes after boot.
>>
>> Trace:
>
> By any chance, are there other messages from btrfs above the line?
>>
>> [  199.974591] ------------[ cut here ]------------
>> [  199.974593] BTRFS: Transaction aborted (error -95)
>
> -95 is EOPNOTSUPP, ie operation not supported
>
>> [  199.974647] WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042 btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
>
> btrfs_finish_ordered_io::
>
>  3038         btrfs_ordered_update_i_size(inode, 0, ordered_extent);
>  3039         ret = btrfs_update_inode_fallback(trans, root, inode);
>  3040         if (ret) {
>  3041                 btrfs_abort_transaction(trans, ret);
>  3042                 goto out;
>  3043         }

I don't know what's exactly in Arch's kernel, but looking at the
4.15.5 stable tag from kernel.org:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/inode.c?h=v4.15.5#n3042

The -EOPNOTSUPP error can come from btrfs_drop_extents() through the
call to insert_reserved_file_extent().
We've had several reports of this kind of error in this location in
the past and they happened to be on filesystems converted from extN to
btrfs.
I don't know however if this filesystem was from such a conversion nor
if those old bugs in the conversion tool were fixed.


>
> the return code is unexpected here. And seeing 'operation not supported'
> after a inode size change looks strange but EOPNOTSUPP could be returned
> from some places.
>
> The transaction is aborted from a thread that finalizes some processing
> so we don't have enough information here to see how it started. I
> suspect there's a file that gets modified short after boot and hits the
> problem. I don't think the EOPNOTSUPP is returned from the lower layers
> (lvm encryption or nvme), so at this point seems like a btrfs bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
