Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:35419 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755330AbcIMUtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 16:49:35 -0400
Received: by mail-qt0-f178.google.com with SMTP id 93so95792756qtg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 13:49:35 -0700 (PDT)
Message-ID: <1473799768.3344.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Tue, 13 Sep 2016 17:49:28 -0300
In-Reply-To: <57D76FB0.4060908@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57D76FB0.4060908@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

One more time I saw the problem. It begins to happen on a daily basis
now. Unfortunately the `enospc_debug` flag did not help. I did not see
any new information in the logs. This time, only a hard reset worked. I
could not even reboot using gnome panel.

Best regards,
Ronan Arraes
