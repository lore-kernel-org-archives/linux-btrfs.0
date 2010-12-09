From: Wayne Pollock <pollock@acm.org>
Subject: Permissions model for btrfs?
Date: Thu, 09 Dec 2010 12:35:35 -0500
Message-ID: <4D011367.70501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I looked though the wiki (and "searched" the archives) but
don't see an answer.  Will btrfs support old POSIX-style ACLs
and permissions, or the new NFS/NT style ACLs like ZFS?  From
the patch I saw, it seems old POSIX ACLs and permissions, but
I'd like to know for sure.  (And maybe the FAQ on the wiki could
address this?)  If it is the older POSIC ACLs, is there any plan
to support NFSv4 ACLs in the future?

On a related note, will btrfs support any ext4 attributes (via chattr)?

Thanks!

-- 
Wayne Pollock
