Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34448 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdGGPFl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 11:05:41 -0400
Received: by mail-qk0-f173.google.com with SMTP id d78so29548201qkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 08:05:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170707054608.GA28035@vader>
References: <20170706150046.GB12959@merlins.org> <20170706211320.GA12206@vader.DHCP.thefacebook.com>
 <20170706212422.GH30689@merlins.org> <20170706230141.GA22242@vader.DHCP.thefacebook.com>
 <20170706233152.GI30689@merlins.org> <20170706234451.GB22242@vader.DHCP.thefacebook.com>
 <20170706235939.GJ30689@merlins.org> <20170707054608.GA28035@vader>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Fri, 7 Jul 2017 18:05:39 +0300
Message-ID: <CAN4oSBe8x3jpMGzdo2F2unqvNT7V+P4VxkaWG3df4DDY+q=TRA@mail.gmail.com>
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
To: Omar Sandoval <osandov@osandov.com>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org,
        pwnall@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was also struggling with this issue for quite some time. Today my 2
months old disk is crashed (which really surprises me). It doesn't
even being shown by `fdisk -l`.

After buying this this disk, I installed a Debian on a BTRFS partition
on an LVM partition on a LUKS partition. From that day till today,
while doing my work, there was always a video running on Youtube in
the background. Sometimes my editor (atom, it also shares a lot with
chromium) was slowing down which was making me end up restarting the
Chromium (and it was restarting barely with `killall -9 chromium`.
Another mentionable event is, 3 days ago my laptop suddenly restarted.

I suspect Chromium usage on BTRFS and disk the crash are somehow related.

2017-07-07 8:46 GMT+03:00 Omar Sandoval <osandov@osandov.com>:
> On Thu, Jul 06, 2017 at 04:59:39PM -0700, Marc MERLIN wrote:
>> On Thu, Jul 06, 2017 at 04:44:51PM -0700, Omar Sandoval wrote:
>> > In the bug report, you commented that CURRENT contained MANIFEST-010814,
>> > is that indeed the case or was it actually something newer? If it was
>> > the newer one, then it's still tricky how we'd end up that way but not
>> > as outlandish.
>>
>> You are correct, my bad.
>> At this point, I'm going to have to assume that something bad happened with
>> rsync when I rsync'ed an old profile over the one that caused chrome to fail
>> to restart.
>> Especially because CURRENT was dated Oct 4th, which does not make sense.
>
> Okay, this makes sense.
>
>> Now that I know what to look for, I'll have a much closer look next time
>> this happens, with the understanding that it would be a while if I've
>> successfully fixed the reason why my laptop was crashing too often.
>
> Sounds good.
>
>> But you said you've also seen issues with google-chrome profile and btrfs.
>> What did you experience?
>
> I never debugged it, but I had to blow away the profile a couple of times. Then
> there's this weird one which looks like a Btrfs bug:
>
> ┌[osandov@vader ~/.config]
> └$ ls -al google-chrome-busted/**
> ls: cannot access 'google-chrome-busted/Local State': No such file or directory
> google-chrome-busted/Default:
> ls: cannot access 'google-chrome-busted/Default/Preferences': No such file or directory
> ls: cannot access 'google-chrome-busted/Default/.com.google.Chrome.VfAUNx': No such file or directory
> total 0
> drwx------ 1 osandov users 12 Feb  7 16:50 .
> drwx------ 1 osandov users 14 Feb  7 16:50 ..
> -????????? ? ?       ?      ?            ? .com.google.Chrome.VfAUNx
> -????????? ? ?       ?      ?            ? Preferences
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
