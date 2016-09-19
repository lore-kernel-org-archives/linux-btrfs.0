Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35748 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932272AbcISS1h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:27:37 -0400
Received: by mail-oi0-f51.google.com with SMTP id w11so207611170oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 11:27:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz> <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com> <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com> <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160919040855.GF21290@hungrycats.org> <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 19 Sep 2016 12:27:35 -0600
Message-ID: <CAJCQCtSZoNYREngbba0NZX4wpeKsOJV21zKu9+v4i23jdcyiAg@mail.gmail.com>
Subject: Re: Is stability a joke? (wiki updated)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 11:38 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>> ReiserFS had no working fsck for all of the 8 years I used it (and still
>> didn't last year when I tried to use it on an old disk).  "Not working"
>> here means "much less data is readable from the filesystem after running
>> fsck than before."  It's not that much of an inconvenience if you have
>> backups.
>
> For a small array, this may be the case.  Once you start looking into double
> digit TB scale arrays though, restoring backups becomes a very expensive
> operation.  If you had a multi-PB array with a single dentry which had no
> inode, would you rather be spending multiple days restoring files and
> possibly losing recent changes, or spend a few hours to check the filesystem
> and fix it with minimal data loss?

Yep restoring backups, even fully re-replicating data in a cluster, is
untenable it's so expensive. But even offline fsck is sufficiently
non-scalable that at a certain volume size it's not tenable. 100TB
takes a long time to fsck offline, and is it even possible to fsck 1PB
Btrfs? Seems to me it's another case were if it were possible to
isolate what tree limbs are sick, just cut them off and report the
data loss rather than consider the whole fs unusable. That's what we
do with living things.


-- 
Chris Murphy
