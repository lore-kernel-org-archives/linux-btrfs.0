Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39531 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934767Ab3IDOiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 10:38:05 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so405327pdj.6
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 07:38:04 -0700 (PDT)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Btrfs prog
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5144EC24-48E9-4AC9-8005-F0A3FA18164A@colorremedies.com>
Date: Wed, 4 Sep 2013 22:37:58 +0800
Cc: Hugo Mills <hugo@carfax.org.uk>, Giuseppe Fierro <giuseppe@fierro.org>,
        linux-btrfs@vger.kernel.org
Message-Id: <5E29539F-9625-488E-AD90-A72A37DF20BD@gmail.com>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com> <20130904133207.GC6389@carfax.org.uk> <5144EC24-48E9-4AC9-8005-F0A3FA18164A@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,
> 
> On Sep 4, 2013, at 3:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>>> If I would like to show the subvolume, i get
>>> 
>>>> gspe@jura:/mnt$ sudo btrfs subvolume list /
>>>> gspe@jura:/mnt$
>>> 
>>> nothing is shown!!!
>> 
>>  Try using the -a option. It got added a while ago, and has been a
>> complete pain in the neck ever since…
> 
> What does -a do?
> 
> I recall with older versions of btrfs-progs that if a subvolume was mounted, btrfs subvol list would only list subvolumes under the one that was mounted, not all subvolumes on the volume. I just tried this with btrfs-progs-0.20.rc1.20130501git7854c8b-4.fc20.x86_64 without -a option, but with a subvolume mounted and the command lists all subvolumes.
> 
> OK now I'm seeing the behavior is sometimes wrong.
> 
> [root@f19v ~]# btrfs subvolume create /mnt/cookies
> Create subvolume '/mnt/cookies'
> [root@f19v ~]# btrfs subvolume create /mnt/chips
> Create subvolume '/mnt/chips'
> [root@f19v ~]# btrfs subvolume create /mnt/nuts
> Create subvolume '/mnt/nuts'
> [root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew
> Create subvolume '/mnt/nuts/cashew'
> [root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew
> ERROR: '/mnt/nuts/cashew' exists
> [root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew/small
> Create subvolume '/mnt/nuts/cashew/small'
> [root@f19v ~]# umount /mnt
> [root@f19v ~]# mount -o subvol=nuts/cashew /dev/sdb /mnt
> [root@f19v ~]# btrfs subvolume list /mnt
> ID 256 gen 5 top level 5 path cookies
> ID 258 gen 10 top level 5 path chips
> ID 259 gen 12 top level 5 path nuts
> ID 260 gen 13 top level 5 path nuts/cashew
> ID 261 gen 13 top level 260 path small

I get the following output:
	cookies
	chips
	nuts
	nuts/cashew
	nuts/cashew/small

Why "small" occurs in your test box?

Thanks,
wang

> 
> 
> The last one should be /nuts/cashew/small. Or the one before it should be cashew instead of nuts/cashew.
> 
> 
> Chris Murphy
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

