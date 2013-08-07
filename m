Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61077 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3HGLdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 07:33:12 -0400
Received: by mail-lb0-f179.google.com with SMTP id v1so1385295lbd.24
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 04:33:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130807104041.GN5284@twin.jikos.cz>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
	<20130807104041.GN5284@twin.jikos.cz>
Date: Wed, 7 Aug 2013 12:33:09 +0100
Message-ID: <CAL3q7H7j1Hfx6p-dxP=+C_6uVa7gG22KTQr2_PphMLy3sPeLyw@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 7, 2013 at 11:40 AM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Aug 06, 2013 at 07:27:20PM +0100, Filipe David Borba Manana wrote:
>> This change allows for most mount options to be persisted in
>> the filesystem, and be applied when the filesystem is mounted.
>> If the same options are specified at mount time, the persisted
>> values for those options are ignored.
>>
>> The only options not supported are: subvol, subvolid, subvolrootid,
>> device and thread_pool. This limitation is due to how this feature
>> is implemented: basically there's an optional value (of type
>> struct btrfs_dir_item) in the tree of tree roots used to store the
>> list of options in the same format as they are passed to btrfs_mount().
>> This means any mount option that takes effect before the tree of tree
>> roots is setup is not supported.
>>
>> To set these options, the user space tool btrfstune was modified
>> to persist the list of options into an unmounted filesystem's
>> tree of tree roots.
>
> We’ve seen this proposed in the past, IIRC this thread contains most of what
> has been discussed:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/19757

Thanks, I missed to find that before.
The implementation is very different from the one I proposed.

>
> Implementing just whole-filesystem mount options is not convering all usecases,
> more broad approach like per-subvolume or per-file settings is desired. There
> are always settings that aren’t known now but would be useful in the future, so
> we need a flexible infrastructure to maintain the properties.
>
> There was a proposed implementation for set/get properties:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/18287

Will take a detailed look at it.
Thanks for pointing it out David.
Why was it never picked?

>
> From the implementation side, I very much want to abandon the separate
> btrfstune utility. Currently it’s a bandaid because there’s nothing better atm.
>
> Designing and merging the properties feature takes time, but we want to tune
> simple things now. The wiki project mentions ‘tune2fs’ as an example, but the
> project details are not always accurate about how to do the things, it’s more
> like ideas what to do. If you’re going to work on that, please claim the
> project on the wiki, and possibly write more details abou the design.

I will.

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
