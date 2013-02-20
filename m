Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:44751 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab3BTT6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 14:58:30 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so3441884eaa.30
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 11:58:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+4EQ5erzw2Z54e7aBNyftUoqUTCM2ORP_-mMVvamPE8a5G=Fg@mail.gmail.com>
References: <CA+4EQ5dZN5YdvsJG+jO1LH8SghH_iedLYo7DN3zk1+m7o0QC9A@mail.gmail.com>
	<20130220181326.GU22221@lenny.home.zabbo.net>
	<CA+4EQ5erzw2Z54e7aBNyftUoqUTCM2ORP_-mMVvamPE8a5G=Fg@mail.gmail.com>
Date: Wed, 20 Feb 2013 20:58:28 +0100
Message-ID: <CA+4EQ5fxTMReAW8tWpzEioPOX-PKME=RXoJV3bqCU72+T6zi0A@mail.gmail.com>
Subject: Re: btrfs doesn't report proper error when removing subvolume
From: Petr Bena <benapetr@gmail.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hm, it's latest ubuntu version (ubuntu 12 LTS) kernel is some 3.2.x I think

On Wed, Feb 20, 2013 at 8:57 PM, Petr Bena <benapetr@gmail.com> wrote:
> hm, it's latest ubuntu version (ubuntu 12 LTS) kernel is some 3.2.x I think
>
>
> On Wed, Feb 20, 2013 at 7:13 PM, Zach Brown <zab@zabbo.net> wrote:
>>
>> > petrb@bots-bnr1:/mnt$ btrfs subvolume delete ext2_saved/
>> > Delete subvolume '/mnt/ext2_saved'
>> > ERROR: cannot delete '/mnt/ext2_saved'
>> >
>> > this is not really very descriptive. It would be really cool if it
>> > told me why it can't delete it.
>>
>> Hmm.  I think this has been fixed for a long time.
>>
>>   [zab@f18 ~]$ btrfs sub delete /mnt/btrfs/blah/
>>   Delete subvolume '/mnt/btrfs/blah'
>>   ERROR: cannot delete '/mnt/btrfs/blah' - Operation not permitted
>>
>>
>> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commit;h=17cf679fb3622a9e3452777d07fcf3a346266ff1
>>
>> Where'd you find that btrfs-progs version? :)
>>
>> - z
>
>
