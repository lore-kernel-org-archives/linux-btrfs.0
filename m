Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36854 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbIIIym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 04:54:42 -0400
Received: by wicgb1 with SMTP id gb1so107383110wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 01:54:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA85sZvff=Bbeak3=eRHL86x6g_uWuxv2s8+Lykjfjy4MeDBbQ@mail.gmail.com>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk> <55EF8CFB.3050103@oracle.com> <CAA85sZvff=Bbeak3=eRHL86x6g_uWuxv2s8+Lykjfjy4MeDBbQ@mail.gmail.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 9 Sep 2015 10:54:21 +0200
Message-ID: <CAA85sZt45B1Kcn_c9sjSO0CiwTYjTLTVgp2o2uWcJL3fHwS-ug@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Anand Jain <anand.jain@oracle.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 September 2015 at 09:07, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> On 9 September 2015 at 03:35, Anand Jain <anand.jain@oracle.com> wrote:
> >  There is a patch set to handle this..
> >     'Btrfs: introduce function to handle device offline'
>
> I'll have a look

So from my very quick look at the code that i could find (can only
find patch set 3 for some reason) this would not fix it properly ;)

(Completely lost all it's formatting but:)
+ if ((rw_devices > 1) &&
+ (degrade_option || tolerated_fail > missing)) {
+ btrfs_sysfs_rm_device_link(fs_devices, dev, 0);
+ __btrfs_put_dev_offline(dev);
+ return;
+ }

I think that this has to be a evaluation on if there is a "complete
copy" on the device(s) we have.
If there is, then we can populate any other device and the system
should still be viable
(this includes things like 'doing the math' to replace missing disks
in raid5 and 6 btw)

Do you have the patches somewhere? They don't seem to apply to 4.2
(been looking at line numbers)
