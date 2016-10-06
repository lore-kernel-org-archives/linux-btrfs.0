Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33105 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbcJFQo0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Oct 2016 12:44:26 -0400
Received: by mail-pf0-f176.google.com with SMTP id 190so11710668pfv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Oct 2016 09:44:26 -0700 (PDT)
Date: Thu, 6 Oct 2016 09:44:14 -0700
From: Dave Olson <olson@cumulusnetworks.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Problem with btrfs_create() getting EBUSY; cause is stale
 highest_objectid at mount - kernel.org bug 173001
Message-ID: <20161006164414.q3mmb3fjqt3ydzrn@cumulusnetworks.com>
References: <20160927211729.GC1601@cumulusnetworks.com>
 <20161004063921.pdcdiapu3zupdcp6@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161004063921.pdcdiapu3zupdcp6@cumulusnetworks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave Olson <olson@cumulusnetworks.com> wrote:

> Dave Olson <olson@cumulusnetworks.com> wrote:
> 
> > The full details are in
> > https://bugzilla.kernel.org/show_bug.cgi?id=173001
> > 
> > Basicly, logrotate has rotated a file to a new name, tries to open a new
> > file with the original name, and gets EBUSY.  The file is not created.

The cause is that the highest_objectid field in the btrfs_root structure
is set incorrectly (an old stale value) at filesystem mount in some
cases.   See the writeup in the bug for more details.

I'm guessing that some of the journal information is not flushed to disk
after btrfs_create(), even when the filesystem is mounted with
flushoncommit, so if a powercycle is done within a few seconds of the
file being created, there is a good chance that this problem will occur
on a subsequent reboot.

btrfs check (up through 4.7.3) does not seem to detect this stale
condition.

Dave Olson
olson@cumulusnetworks.com
