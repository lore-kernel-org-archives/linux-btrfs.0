Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40182 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2IMGH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 02:07:28 -0400
Received: by oago6 with SMTP id o6so1616046oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 23:07:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 13 Sep 2012 14:07:27 +0800
Message-ID: <CACHiF8CwqRDkNeDTaDGb_jMJru1_Vn0AJ0_bqg74P7C92TzvJQ@mail.gmail.com>
Subject: specify UUID for btrfs
From: ching lu <lsching17@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible to specify UUID for btrfs when creating the filesystem?
or changing it when it is offline?


i have several script/setting file which have hardcoded UUID and i do
not want to update them every time when restore backup.
