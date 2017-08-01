Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35185 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdHASsm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:48:42 -0400
Received: by mail-wm0-f42.google.com with SMTP id m85so22768237wma.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 11:48:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFcRpx5JkNnTOtrVbjTe6e7tde=Sw3_78TAJThEd+cYtx62h4w@mail.gmail.com>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <CAJCQCtQ=NXO_ZG0ZUnvhMZQYSrK9+LEBjhMKVYUG1gOnioKVig@mail.gmail.com> <CAFcRpx5JkNnTOtrVbjTe6e7tde=Sw3_78TAJThEd+cYtx62h4w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 1 Aug 2017 12:48:40 -0600
Message-ID: <CAJCQCtR_Ocz5_JPTmZWdKc8tZM2Y7Qj=0DLx3igsZmfKr=1jCw@mail.gmail.com>
Subject: Re: Raid0 rescue
To: Alan Brand <alan@georgiabrands.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 1, 2017 at 12:36 PM, Alan Brand <alan@georgiabrands.com> wrote:
> I successfully repaired the superblock, copied it from one of the backups.
> My biggest problem now is that the UUID for the disk has changed due
> to the reformatting and no longer matches what is in the metadata.
> I need to make linux recognize the partition as btrfs and have the correct UUID.
> Any suggestions?

Huh, insofar as I'm aware, Btrfs does not track a "disk" UUID or partition UUID.

A better qualified set of steps for fixing this would be:

a.) restore partitioning, if any
b.) wipefs the NTFS signature to invalidate the NTFS file system
c.) use super-recover to replace correct supers on both drives
d.) mount the file system
e.) do a full scrub

The last step is optional but best practice. It'll actively do fixups,
and you'll get an error message with path to files that are not
recoverable.

Alternatively a metadata only balance will do fixups, and it'll be
much faster. But you won't get info right away about what files are
damaged.


-- 
Chris Murphy
