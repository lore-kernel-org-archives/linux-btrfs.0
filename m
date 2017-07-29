Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36616 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdG2T3s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 15:29:48 -0400
Received: by mail-lf0-f43.google.com with SMTP id o85so42121535lff.3
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 12:29:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Sat, 29 Jul 2017 21:29:46 +0200
Message-ID: <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/9/17, Duncan <1i5t5.duncan@cox.net> wrote:
> I have however just upgraded to new ssds then wiped and setup the old
> ones as another backup set, so everything is on brand new filesystems on
> fast ssds, no possibility of old undetected corruption suddenly
> triggering problems.
>
> Also, all my btrfs are raid1 or dup for checksummed redundancy

Do you have any experience/advice/comment regarding
dup data on ssds?
