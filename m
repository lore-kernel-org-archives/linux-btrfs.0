Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:49573 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdJaOpt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:45:49 -0400
Received: by mail-io0-f177.google.com with SMTP id n137so35664066iod.6
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 07:45:49 -0700 (PDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: btrfs-subv-backup v0.3b
Message-ID: <289afe3e-53ad-3803-fb6d-28f3238e67ff@gmail.com>
Date: Tue, 31 Oct 2017 10:45:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new version of btrfs-subv-backup has just been uploaded to github.
Yes, I know I skipped v0.2b, I actually did upload a version v0.2b, I 
just forgot to post anything about it here...

Changes since the last time I posted here:

v0.2b:
     * Updated the LICENSE file so that GitHub properly recognizes it as 
a 3-clause BSD license.
     * Tidied up README.md and clarified some things.
     * We now skip existing subvolumes that are where they are supposed 
to be instead of trying to replace them and throwing an error at the 
end.  This means you can restore on a partially restored tree.
     * Permissions and timestamps for subvolumes are copied correctly now.
     * If running as root, subvolume ownership is also copied correctly now.
     * You can now use the flag `--verbose` or `-v` to get some progress 
info.
     * Permissions and ownership are properly preserved for files and 
directories under restored subvolumes.
     * Added an optional dependency on the 'reflink' module [1].  If 
present on the system, it will be used by default when restoring subvolumes.
     * Added an option `--method` to explicitly specify what method to 
use for restoring subvolumes.

v0.3b:
     * Failures to call blkid are now non-fatal (they technically were 
already, but were being treated as fatal errors).
     * The reflink method for restoring subvolumes now falls back 
gracefully to the copy method if a reflink fails.
     * btrfs-subv-backup will now bail early if it is told to create a 
subvolume where a mount point already exists, instead of failing at the 
end of restoring the subvolume.
     * Added better info on dependencies to the README, and properly 
spell checked it.
