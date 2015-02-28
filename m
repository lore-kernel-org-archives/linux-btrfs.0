Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46863 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbB1JhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Feb 2015 04:37:05 -0500
Received: by lbjf15 with SMTP id f15so21437685lbj.13
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2015 01:37:03 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAP6pX26-_bnm-PKz3SQ1C+Xv5biz_e_2w8WX8syNeozUbTgnMw@mail.gmail.com>
References: <CAP6pX26-_bnm-PKz3SQ1C+Xv5biz_e_2w8WX8syNeozUbTgnMw@mail.gmail.com>
Date: Sat, 28 Feb 2015 09:37:03 +0000
Message-ID: <CAL3q7H6ymZu6xYffdZ-UFP2Pqr4VHEcFpAWf0KbR_Gsd0v_EcA@mail.gmail.com>
Subject: Re: Receive "directory not empty" bug
From: Filipe David Manana <fdmanana@gmail.com>
To: Ames Cornish <ames@cornishes.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 28, 2015 at 2:05 AM, Ames Cornish <ames@cornishes.net> wrote:
> Hi,
>
> btrfs is consistently refusing to receive send of certain directories.
> It fails with the message "Directory not empty" for an internal
> directory on the receiving side.  Any ideas on what this might be or
> how to troubleshoot it?
>
> Here's an example:
>
> btrfs-progs v3.19-rc2
> root@ProLiant:/mnt/backup/bug# uname -a
> Linux ProLiant 3.18.7-031807-generic #201502110759 SMP Wed Feb 11
> 08:01:01 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> root@ProLiant:/mnt/backup/bug# btrfs send /bak/Portege/2014-06-01 |
> btrfs rec -v .
> At subvol /bak/Portege/2014-06-01
> At subvol 2014-06-01
> receiving subvol 2014-06-01 uuid=f80254c5-2f5a-b043-ad3e-e12287f7b7e8,
> stransid=105481
> BTRFS_IOC_SET_RECEIVED_SUBVOL
> uuid=f80254c5-2f5a-b043-ad3e-e12287f7b7e8, stransid=105481
> root@ProLiant:/mnt/backup/bug# btrfs send -p /bak/Portege/2014-06-01
> /bak/Portege/2014-12-01_01-02-44 | btrfs rec -vvvv .
> At subvol /bak/Portege/2014-12-01_01-02-44
> At snapshot 2014-12-01_01-02-44
> receiving snapshot 2014-12-01_01-02-44
> uuid=b277e2ab-f0af-1e46-a8a3-cd587fd64a53, ctransid=474567
> parent_uuid=f80254c5-2f5a-b043-ad3e-e12287f7b7e8,
> parent_ctransid=105481
> utimes
> rename .duplicity -> o257-9667-0
> mkdir o257-473948-0
> rename o257-473948-0 -> .duplicity
> utimes
> chown .duplicity - uid=0, gid=100
> chmod .duplicity - mode=02775
> utimes .duplicity
> rename .ecryptfs -> o258-9667-0
> mkdir o258-473948-0
> rename o258-473948-0 -> lost+found
> utimes
> chown lost+found - uid=0, gid=0
> chmod lost+found - mode=0700
> utimes lost+found
> rmdir lost+found
> mkdir o259-473948-0
> rename o259-473948-0 -> monitor
> ERROR: rename o259-473948-0 -> monitor failed. Directory not empty
> -- Ames

Hi,

Can you please send the output of the following commands:

tree --inodes -d /bak/Portege/2014-06-01
tree --inodes -d /bak/Portege/2014-12-01_01-02-44

That should give me enough information to reproduce and fix it.

thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
