Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33937 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbcI0VRd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 17:17:33 -0400
Received: by mail-pa0-f51.google.com with SMTP id gp7so9245353pac.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Sep 2016 14:17:33 -0700 (PDT)
Date: Tue, 27 Sep 2016 14:17:29 -0700
From: Dave Olson <olson@cumulusnetworks.com>
To: linux-btrfs@vger.kernel.org
Subject: Problem with btrfs fs in 4.1.25 - getting EBUSY on file create -
 kernel.org bug 173001
Message-ID: <20160927211729.GC1601@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The full details are in
https://bugzilla.kernel.org/show_bug.cgi?id=173001

Basicly, logrotate has rotated a file to a new name, tries to open a new
file with the original name, and gets EBUSY.  The file is not created.

Later on the file can be created with no problems.

I've turned on most of the BTRFS config options, and there are no BTRFS
messages related to the failure.

The file is on the root filesystem.


Dave Olson
olson@cumulusnetworks.com
