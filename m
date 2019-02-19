Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385FDC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8FF2146F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvUEoDjF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfBSTqJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:46:09 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:37153 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfBSTqI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 14:46:08 -0500
Received: by mail-it1-f171.google.com with SMTP id z124so9269728itc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 11:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kjTNBUrW7rqSPxD2uOQtxqPL+dGNC8rplyA7dSEcEto=;
        b=AvUEoDjFD6GGYC8YaHvS0zCIS+XVr1e0Bpqckq6q49IxTRN0yhBJHpYk13+aN+pU9+
         JaGArrCIYgfhdQ1ps/05a0sHXRMou1AeeGour0HGghOXjiBkwgQKjspYHBxcpTCN0wJ4
         OItZnVpCNDJYfr9cHzIcbd03/PcfcQCmzbh/LU6LjldHpk+OtEeyMbkN7yt4s0VgBo1l
         JyKwWAQ/BA6i/099M8Hl/ugCgkye6LXMnQJBSoJFsJJfIpfSV+pqOFjRi/yPepnr2Rlx
         GSyKjf8XMgAmfnEe2adDCtGmKr4GxhLGKcd8uwj9Q91HItHIRe7tujGb2QiMjwLhMoWa
         jqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kjTNBUrW7rqSPxD2uOQtxqPL+dGNC8rplyA7dSEcEto=;
        b=kcYgYjikdG6In5zaB/2i2FvbMcYbKSeLUJoOK40mQaFFUTHu/b4WeY7gFT8s3kYjXy
         EwbJQkL0+vklJjtFmPMjz6CLLemN/v4AagsaLpjjYk/+YU9Bec2ExzFP77Pauy8MlL42
         Yg2E6nQauh/as2iA7r0gknnp/3NrUxHgKd5Zxh/im6XOEMG4SgYf8149su4u1aCIi1LX
         DqzJvNlHuae5kEMBVZTfjtsbsUC1JTHHg+ESF3Arr/VL8Y5lAXgH9c5EvLI0gIUNdVjc
         4L4kDCMwtSKBe+AoUyP4AW6J2p3+q4SqtSXWhieJFdtSQGIu6qWSkV/NY/hS5/Zv+B/E
         PrPA==
X-Gm-Message-State: AHQUAubL+cBo/lqFSvUb2ID7sM5LGyHU+WOgO/adVTO0+D/HMNEaTEpE
        2CzFx2tOHm/fSAqJuCIZV8QixkEHWj534WRqeAE=
X-Google-Smtp-Source: AHgI3IbOXG7BXW+kiIo79V4gO37wyiLpVTKQI5GBKG27QoI0PihOwh+B5+OwBMLFsY/E3FzSb2iJ9DDOK+OTnu+64zc=
X-Received: by 2002:a6b:b5c7:: with SMTP id e190mr17307407iof.26.1550605567600;
 Tue, 19 Feb 2019 11:46:07 -0800 (PST)
MIME-Version: 1.0
From:   Jesper Utoft <jesper.utoft@gmail.com>
Date:   Tue, 19 Feb 2019 20:45:56 +0100
Message-ID: <CAOna0f3MMZLxsOdT81z0dYDzikmzdmV=X73a-+k1jhdBT60AEQ@mail.gmail.com>
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> On Thu, Feb 14, 2019 at 08:25:26PM +0800, Qu Wenruo wrote:
>> On 2019/2/14 =E4=B8=8B=E5=8D=887:58, Jesper Utoft wrote:
>>> Hello Fellow BTRFS users.
>>>
>>> I have run into the bad key order issue.
>>> corrupt leaf: root=3D1 block=3D57567265079296 slot=3D83, bad key orde=
r, prev
>>> (18446744073709551605 0 57707594776576) current (18446726481523507189=

>>> 0 57709742260224)
>>> The lines repeats over and over..
>>>
>>> I read a thread between Hugo Mills and Eric Wolf about a similar issu=
e
>>> and i have gathered the same info.=20
>> Now we have all the needed info.
>>
>>>
>>> I understand that it probably is hardware related, i have been runnin=
g
>>> memtest for 60h+ to see if i could reproduce it.
>>> I also tried to run btrfs check --recover but it did not help.
>>>
>>> My questions is if it can be fixed?
>>
>> Yes, but only manual patching is possible yet.
>=20
>    David: What needs to be done to get the bitflip-in-key patches
> added to btrfs check? They've been lurking in some patch stack for
> literally years, and would have dealt with this one easily.

[snip]

>=20
> [snip]
>> Thankfully, all keys around give us a pretty good idea what the origin=
al
>> value should be: (FREE_SPACE UNTYPED 57709742260224).
>>
>> And for the raw value:
>> bad:  0xffffeffffffffff5
>> good: 0xfffffffffffffff5
>>             ^
>> e->f, one bit get flipped.
>> (UNTYPED is the same value for UNKNOWN.0, so don't worry about that).
>>
>> I have created a special branch for you:
>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>>
>> Just compile that btrfs-progs, no need to install, then excute the
>> following command inside btrfs-progs directory:
>>
>> # ./btrfs-corrupt-block -X <device>
>=20
>    BUT, don't do it until you've found and replaced the bad RAM that
> broke it in the first place.

I got the code to build & ran as described above. I do not know if it
worked and there were many other errors, or if it failed and just
moved the issue elsewhere.
In any case i had a few subvolumes with missing files so i have been
send receiving the subvolumes i can, and cp'ed the ones that i could
not.
Now it's running in a new btrfs volume on a new disk. And i will
probably use snapraid or a transfer of subvolumes between btrfs
filesystems for "backup" instead of a raid 1. Which i expect would be
a more sane approach anyway.

>=20
>> And your report just remind me to update the write time tree block
>> checker....
>=20
>    Looking forward to dealing with a whole new type of "btrfs is
> broken!" complaints on IRC (followed by "can't I just let it carry on
> regardless?"). ;)

Thank you all for the very quick assistance. Especially for the "dirty
fix" even though the volume was damaged too much to fix.

I will save money for a new hardware setup with ecc ram, for now i
will have to hope for the best, and keep taking regular backups.

Thanks
Jesper Utoft
Ps: I'm not a member of the mailing list, so if you reply please do
reply to me direcly as well.
