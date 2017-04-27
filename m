Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:44852 "EHLO
        mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S939060AbdD0U1r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 16:27:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id DE0D6C433
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 20:18:03 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oxPRsJiZSzl4 for <linux-btrfs@vger.kernel.org>;
        Thu, 27 Apr 2017 20:18:03 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Subvolume copy fails with "ERROR: empty stream is not considered
 valid"
Cc: =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>
Message-ID: <094d0920-ffa1-bd2b-0846-35fd01a972e3@mokrynskyi.com>
Date: Thu, 27 Apr 2017 23:18:02 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just reported a bug (https://bugzilla.kernel.org/show_bug.cgi?id=195597) that hit me after recent update of btrfs-progs.

It seems to be a false-positive that resulted from the changes that aimed to fix another issue.

Short version of it is following:

root@nazar-pc:~# /bin/btrfs send  "/media/Backup/web/2017-04-04_14:30:06" | /bin/btrfs receive "/media/Backup_backup/web"
At subvol /media/Backup/web/2017-04-04_14:30:06
At subvol 2017-04-04_14:30:06
ERROR: empty stream is not considered valid

I've also added Stéphane Graber to CC as the author of the recent update to Ubuntu's btrfs-progs package.

I'm not subscribed to the mailing list, so keep me in copy, please.

-- 
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8EF5261249

