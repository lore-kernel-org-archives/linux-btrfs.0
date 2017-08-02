Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52955 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdHBMzb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 08:55:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dctBF-0007ki-Cg
        for linux-btrfs@vger.kernel.org; Wed, 02 Aug 2017 14:55:17 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Date: Wed, 02 Aug 2017 14:55:10 +0200
Message-ID: <olsi37$qhm$1@blaine.gmane.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <1cfc817b-2f35-9ca5-9d6c-ab2c6ec53ba9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <1cfc817b-2f35-9ca5-9d6c-ab2c6ec53ba9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2017 01:25 PM, Austin S. Hemmelgarn wrote:
> And this is a worst-case result of the fact that most
> distros added BTRFS support long before it was ready.

RedHat still advertises "Ceph", and given Ceph initially recommended btrfs as
the filesystem to use for its nodes, it is interesting to read how clearly
they recommend against btrfs now:

http://docs.ceph.com/docs/master/rados/configuration/filesystem-recommendations/
> We recommand against using btrfs due to the lack of a stable version
> to test against and frequent bugs in the ENOSPC handling.

German IT magazine "Golem" speculates that RedHat's decision
is influenced by its recent acquisition of Permabit.

But I don't really see how XFS or Permabit tackle the problem
that if you need to create consistent backups of file systems while they are
in use, block-device level snapshots damage the write performance
big time.

(That backup topic is the one reason we use btrfs for a lot of
/home/ directories.)

I understand that XFS is expected to get some COW-features in the future
as well - but it remains to be seen what performance and robustness
implications that will have on XFS.

Regards,

Lutz Vieweg

