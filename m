Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51764 "HELO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751908Ab2JQIJ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 04:09:59 -0400
Received: by mail-ea0-f198.google.com with SMTP id c11so2832467eaa.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 01:09:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+nK0aMXO31DZOz3q279wuswY4Sa6GqP7Ad6MG73E-AWP2+rNw@mail.gmail.com>
References: <CA+nK0aMXO31DZOz3q279wuswY4Sa6GqP7Ad6MG73E-AWP2+rNw@mail.gmail.com>
From: Sami Haahtinen <sami@haahtinen.name>
Date: Wed, 17 Oct 2012 11:09:37 +0300
Message-ID: <CA+nK0aNs+kJGos2e5T0tjLv-ZKWO41CdeHA2Zy6vG60LBMjvTw@mail.gmail.com>
Subject: Re: filesystem in such a state that btrfsck crashes
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 16, 2012 at 11:25 PM, Sami Haahtinen <sami@haahtinen.name> wrote:
> The kernel I started seeing the problems is 3.6.0 and I was on 3.6.2
> during the few final moments. I have backups of the filesystem, but
> I'm a bit curious what is causing this. I've seen mentions of other
> segfault causing problems, so if there is anything I can do to help
> debug the cause for the segfault, I'd be happy to help.

After a bit of investigating I noticed that I was unable to delete
some of the snapshots, so the problem is most likely related to
snapshots.

root@sysresccd /mnt/windows % btrfs sub del @apt-snap*
Delete subvolume '/mnt/windows/@apt-snapshot-2012-09-25_17:01:15'
ERROR: cannot delete '/mnt/windows/@apt-snapshot-2012-09-25_17:01:15'
- Directory not empty
Delete subvolume '/mnt/windows/@apt-snapshot-2012-09-25_17:01:16'
ERROR: cannot delete '/mnt/windows/@apt-snapshot-2012-09-25_17:01:16'
- Directory not empty
[...]

The unmount process after the deletion has now taken quite a while
(over an hour) and I'm not really expecting it to complete.

Regards,
-- 
Sami Haahtinen
Bad Wolf Oy
+358443302775
