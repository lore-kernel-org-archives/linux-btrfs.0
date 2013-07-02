Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57584 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3GBN20 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 09:28:26 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd20so5519978obb.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jul 2013 06:28:25 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 14:28:25 +0100
Message-ID: <CAMoswei+L-kH_O9uRecOorpS6Kf5hnZ9j3nxZ36kzFR6G9uXeg@mail.gmail.com>
Subject: Does balance implicitly defrag?
From: Paul Richards <paul.richards@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I run "btrfs filesystem balance", does this implicitly
defragment the filesystem?  (Assuming there is plenty free space)

--
Paul Richards
@pauldoo
