Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33115 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbcIJT1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 15:27:04 -0400
Received: by mail-oi0-f50.google.com with SMTP id y2so219323407oie.0
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Sep 2016 12:27:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com> <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net> <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net> <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
 <CAJCQCtSmFA2iRDN33u9XF1b4nN_xA5sy44tS3n5mnA4f+go_hg@mail.gmail.com>
 <8049c767-5cf0-7abc-8e44-828a15619546@gmail.com> <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 10 Sep 2016 13:27:02 -0600
Message-ID: <CAJCQCtSt=rH59nu5ttOdqZkDLdLn60hd0=LL0-oECrzVhk0K-A@mail.gmail.com>
Subject: Re: Security implications of btrfs receive?
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 9, 2016 at 12:58 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> It should work better than it does because it works well for LVM and
> mdadm arrays.
>
> I think what's going on is the DE's mounter (udisksd) tries to mount
> each Btrfs device node, even though those nodes make up a single fs
> volume.

I updated this bug but it looks like it's going to a maintainer whose
not reading these mails.
https://bugs.freedesktop.org/show_bug.cgi?id=87277#c3

Anyway the problem is pretty bad as I describe in that bug. It pretty
much will always cause some kind of Btrfs corruption, which does get
fixed if everything is raid1. The main flaw is that it uses sysfs to
delete the device node before umounting the file system, so it causes
any multiple device Btrfs array that's automounted to become degraded.
There's something of a silver lining so long as the metadata at least
is raid1, which it probably ought to be, rather than single, dup, or
raid0.

In any case, it's far worse and more dangerous than LVM or mdadm raid
which don't exhibit this behavior. So of the available short term
options I see, udisks2 (and now storaged) needs to black list Btrfs
from automounting. It's just not smart enough to make sure it's not
doing really wrong things.



-- 
Chris Murphy
