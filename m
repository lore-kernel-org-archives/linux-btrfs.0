Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34462 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753544AbdIRNoD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 09:44:03 -0400
Received: by mail-lf0-f66.google.com with SMTP id h80so333880lfe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 06:44:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d4dce3d04c11e171b44a1924114f5ddd@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org> <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com> <d4dce3d04c11e171b44a1924114f5ddd@wpkg.org>
From: Peter Becker <floyd.net@gmail.com>
Date: Mon, 18 Sep 2017 15:44:01 +0200
Message-ID: <CAEtw4r19d8GsvzLD_OxBYxb7DoetpvmD3HySGKB9sFWtMQgF5A@mail.gmail.com>
Subject: Re: how to run balance successfully (No space left on device)?
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i'm not sure if it would help, but maybe you could try adding an 8GB
(or more) USB flash drive to the pool and try to start balance.
if it works out, you can throw him out of the pool after that.
