Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36099 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdKZLhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 06:37:11 -0500
Received: by mail-vk0-f48.google.com with SMTP id p144so15823332vkp.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Nov 2017 03:37:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC_aE4bHsp6pOBibFsMa_5inO9sgb-djx5Dc903-sR3=Nw@mail.gmail.com>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com> <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com> <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com> <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
 <ccdf8c94-3fae-8c04-7b4f-b5bb7546ed06@gmx.com> <CAKuJGC930Nm4pNqA+xH5HRbx0pWBKR4KXnS32hP+NYSdvO7arA@mail.gmail.com>
 <9932efee-4784-60db-114f-a6ce3ed01b7c@gmx.com> <CAKuJGC_aE4bHsp6pOBibFsMa_5inO9sgb-djx5Dc903-sR3=Nw@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 26 Nov 2017 17:06:30 +0530
Message-ID: <CAKuJGC8C3-yZG9AwBfXQAPHQUrub7W6BfrdrEGwLuahbXYVw0A@mail.gmail.com>
Subject: Re: misc/021-image-multi-devices fails on latest btrfs-devel/misc-next
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I checked with David, Seems like his github/repo.or.cz repo has latest
dev patches
before pushing them into kernel.org repo.

--
With the help of 'git bisect', managed to debug this issue further.
With this patch[1]
applied we are running into this issue.

https://asciinema.org/a/OMLXpd69iHaej0Xfsrr2ihKiP

[1] btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
https://github.com/kdave/btrfs-devel/commit/25908a59bb5c54f896c646ed3a1f73b2727ad9b5

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Fri, Nov 24, 2017 at 5:35 PM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
>>>>
>>>> To make it clear, what kernel config and commit are you using when the
>>>> test fails?
>>>>
>>> When I use attached kernel config along with tar from misc-next branch
>>> (wget https://github.com/kdave/btrfs-devel/archive/misc-next.zip) this
>>> issue happens.
>>
>> BTW, David seems to update his branch more often in his git.kernel.org
>> branch than github.
>>
>> So it's possible that the branch from github is out dated.
>
> Okay, I didn't know that one, let me checkout his git.kernel.org branch and
> check the results there.
>
>>
>> For v4.14-rc7, even I enabled all the btrfs related configs, I still
>> can't reproduce it.
>> ------
>> $ zcat /proc/config.gz  | grep BTRFS
>> CONFIG_BTRFS_FS=m
>> CONFIG_BTRFS_FS_POSIX_ACL=y
>> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
>> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
>> CONFIG_BTRFS_DEBUG=y
>> CONFIG_BTRFS_ASSERT=y
>> ------
>>
>> So there is something strange happened.
>>
>
> Yes. something strange going on. I use the same kernel config
> for misc-next, 4.14 and 4.14.2 - issue happens only with
> misc-next, as you mentioned it may not be up-to-date.
>
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
