Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34250 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbcJDGjb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Oct 2016 02:39:31 -0400
Received: by mail-pa0-f46.google.com with SMTP id rz1so14674210pab.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Oct 2016 23:39:30 -0700 (PDT)
Date: Mon, 3 Oct 2016 23:39:21 -0700
From: Dave Olson <olson@cumulusnetworks.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Problem with btrfs fs in 4.1.25 (also 4.8.0) - getting EBUSY on
 file create - kernel.org bug 173001
Message-ID: <20161004063921.pdcdiapu3zupdcp6@cumulusnetworks.com>
References: <20160927211729.GC1601@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160927211729.GC1601@cumulusnetworks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave Olson <olson@cumulusnetworks.com> wrote:

> The full details are in
> https://bugzilla.kernel.org/show_bug.cgi?id=173001
> 
> Basicly, logrotate has rotated a file to a new name, tries to open a new
> file with the original name, and gets EBUSY.  The file is not created.
> 
> Later on the file can be created with no problems.
> 
> I've turned on most of the BTRFS config options, and there are no BTRFS
> messages related to the failure.
> 
> The file is on the root filesystem.

This problem is also reproducible on a 4.8 kernel.org kernel with no
modifications, built today from the 4.8 tag.

It happened on the 77th powercycle, after about 3 hours.

Dave Olson
olson@cumulusnetworks.com
