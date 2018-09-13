Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbeIMNtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:49:02 -0400
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>, linux-btrfs@vger.kernel.org
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
Date: Thu, 13 Sep 2018 11:40:32 +0300
MIME-Version: 1.0
In-Reply-To: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 11:34, Jürgen Herrmann wrote:
> Hello!
> 
> I have a newly installed laptop running a freshly installed (abt. two
> months ago) laptop running latest linux mint 19. Root filesystem is on a
> 1TB Samsung 860 M.2 SSD with btrfs on top of a LUKS encrypted 900G
> partition. Timeshift-btrfs is enabled for root (@) and home (@home)
> subvolumes. I want to transfer snapshots to a server with a separated
> disk via "btrfs send" and ssh.
> 
> Here's the list of snapshot directories, each containing tow snapshots
> for root and home:
> 
> drwxr-xr-x 1 root root 30 Sep 12 22:08 2018-08-16_20-00-01
> drwxr-xr-x 1 root root 30 Aug 17 14:00 2018-08-17_14-00-02
> drwxr-xr-x 1 root root 30 Aug 23 20:00 2018-08-23_20-00-01
> drwxr-xr-x 1 root root 30 Aug 30 20:00 2018-08-30_20-00-01
> drwxr-xr-x 1 root root 30 Sep  6 20:00 2018-09-06_20-00-01
> drwxr-xr-x 1 root root 30 Sep  6 22:00 2018-09-06_22-00-01
> drwxr-xr-x 1 root root 30 Sep  8 16:00 2018-09-08_16-00-01
> drwxr-xr-x 1 root root 30 Sep 10 20:00 2018-09-10_20-00-02
> drwxr-xr-x 1 root root 30 Sep 11 21:00 2018-09-11_21-00-02
> drwxr-xr-x 1 root root 30 Sep 12 21:00 2018-09-12_21-00-01
> 
> "btrfs send
> /mnt/timeshift/backup/timeshift-btrfs/snapshots/2018-08-16_20-00-01/@
>>/dev/null" results in the btrfs task taking 100% cpu time on one cpu
> and then all IO is blocked -> only reboot can solve the hang.
> 
> The crash does not happen immediately, as i was on the road using
> cellular connection it seemed fine at first. That's how I found out that
> it transfers ~140MB of data before hanging. The snapshot is created on
> the server and contains data (du shows abt 140MB).
> 
> I am running vanilla kernel 4.18.6 (compiled by myself) and btrfs progs
> 4.17.1 compiled from source.
> 
> Here's the btrfs filesystem info:
> Label: none  uuid: a914c141-72bf-448b-847f-d64ee82d8b7b
>         Total devices 1 FS bytes used 342.85GiB
>         devid    1 size 875.44GiB used 357.05GiB path
> /dev/mapper/sda3_crypt
> 
> A scrub shows no errors:
> scrub status for a914c141-72bf-448b-847f-d64ee82d8b7b
>         scrub started at Thu Sep 13 10:20:18 2018 and finished after
> 00:12:19
>         total bytes scrubbed: 342.78GiB with 0 errors
> 
> What can I do to help debugging this issue?


You should provide output of echo w > /proc/sysrq-trigger. Also
sample the stack of /proc/[pid of btrfs send]/stack to see if it is
changing.


> 
> Best regards,
> Jürgen
