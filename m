Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:36184 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751574AbdC0GRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 02:17:08 -0400
Received: from smtp10.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp10.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id F1B755E4C
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 01:57:18 -0400 (EDT)
Received: by smtp10.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id A886F6301
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 01:57:18 -0400 (EDT)
Subject: Re: backing up a file server with many subvolumes
To: linux-btrfs@vger.kernel.org
References: <58D72EC4.9020101@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <59dccd7e-6cb6-ea66-3150-0ce85472e73a@rqc.ru>
Date: Mon, 27 Mar 2017 08:57:17 +0300
MIME-Version: 1.0
In-Reply-To: <58D72EC4.9020101@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just some consideration, since I've faced similar but no exactly same 
problem: use rsync, but create snapshots on target machine. Blind rsync 
will destroy deduplication of your snapshots and take huge amount of 
storage, so it's not a solution. But you can rsync --inline your 
snapshots in chronological order to some folder and re-take snapshots of 
that folder, thus recreating your snapshots structure on target. 
Obviously, it can/should be automated.


--

With Best Regards,
Marat Khalili

On 26/03/17 06:00, J. Hart wrote:
> I have a Btrfs filesystem on a backup server.  This filesystem has a 
> directory to hold backups for filesystems from remote machines. In 
> this directory is a subdirectory for each machine.  Under each machine 
> subdirectory is one directory for each filesystem (ex /boot, /home, 
> etc) on that machine.  In each filesystem subdirectory are incremental 
> snapshot subvolumes for that filesystem.  The scheme is something like 
> this:
>
> <top>/backup/<machine>/<filesystem>/<many snapshot subvolumes>
>
> I'd like to try to back up (duplicate) the file server filesystem 
> containing these snapshot subvolumes for each remote machine.  The 
> problem is that I don't think I can use send/receive to do this. 
> "Btrfs send" requires "read-only" snapshots, and snapshots are not 
> recursive as yet.  I think there are too many subvolumes which change 
> too often to make doing this without recursion practical.
>
> Any thoughts would be most appreciated.
>
> J. Hart
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

