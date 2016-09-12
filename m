Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34191 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbcILUZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 16:25:30 -0400
Received: by mail-oi0-f53.google.com with SMTP id m11so333720584oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 13:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <03d03ce6-4dad-bad9-311d-a040e4122128@gmail.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com> <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net> <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net> <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
 <CAJCQCtSmFA2iRDN33u9XF1b4nN_xA5sy44tS3n5mnA4f+go_hg@mail.gmail.com>
 <8049c767-5cf0-7abc-8e44-828a15619546@gmail.com> <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
 <03d03ce6-4dad-bad9-311d-a040e4122128@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 12 Sep 2016 14:25:28 -0600
Message-ID: <CAJCQCtSLVvvywicedgYUWYY2a-DdWm9bW6=Vct-hX462vpQnKg@mail.gmail.com>
Subject: Re: Security implications of btrfs receive?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 5:24 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> After device discovery, specify UUID=<volume UUID> instead of a device node.

Oh yeah good point, -U --uuid is also doable. I'm not sure what the
benefit is of using sysfs to delete a device's node after umounting.
If the umount isn't successful or the accounting for all mount points
isn't right, there is no warning for device delete, it's gone and it's
like physically yanking the device out of the port. Seems dangerous
for udisksd to use that?



> I personally feel it's more important that we fix the whole UUID issue
> first.  If we fix that, it is likely to at least make things better in this
> particular case as well.

Fair enough.

> The problem with trying to get this fixed upstream
> in userspace is that udisks is essentially deprecated because of the work on
> storaged (which will almost certainly depend on systemd), so you're almost
> certainly get nothing fixed until someone decides to fork it and maintain it
> themselves like happened for ConsoleKit.
>
> As far as what udisks is doing wrong, based on what you've said and minimal
> experimentation on my systems, the issue is that it's not identifying the
> array as one filesystem.  They mount by device node to try and avoid the
> UUID issues (because they affect every filesystem to some degree), but
> because of that they see a bunch of filesystems.

By trying to avoid the UUID issues, they end up with another problem.
I guess right now the only sure fire options they have:

a. Don't automount any Btrfs. (This is what I've recommended.)
b. pass --uuid as well as device= for each device in the array as
discovered by BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO: while also not
mounting by device node alone for Btrfs.



-- 
Chris Murphy
