Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-5.smtp-out.eu-west-1.amazonses.com ([54.240.4.5]:58422 "EHLO
        a4-5.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752754AbdKBPCv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 11:02:51 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Martin Raiber <martin@urbackup.org>
Subject: Multiple btrfs-cleaner threads per volume
Message-ID: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
Date: Thu, 2 Nov 2017 15:02:48 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

snapshot cleanup is a little slow in my case (50TB volume). Would it
help to have multiple btrfs-cleaner threads? The block layer underneath
would have higher throughput with more simultaneous read/write requests.

Regards,
Martin Raiber

