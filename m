Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:50090 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3ANSZe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:25:34 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so4248526lab.15
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 10:25:33 -0800 (PST)
Message-ID: <50F44DB6.4090802@gmail.com>
Date: Mon, 14 Jan 2013 19:25:58 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/11 V3] add show command to the subvol sub command
In-Reply-To: <50F383BF.3050204@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
 <50F383BF.3050204@oracle.com>

On 01/14/2013 05:04 AM, Anand Jain wrote:
> 
> 
> Any comments on this new sub-command, please. ?
> 
> Thanks, Anand
> 
I am trying to use this new command. Very nice. However I tried to use
it against the root of filesystem, without success:

The root of filesystem is under /var/btrfs; I used a subvolume as root:

$ cat /proc/self/mountinfo  | grep sdc3
19 1 0:15 /__active / rw,noatime,nodiratime - btrfs /dev/sdc3 rw,space_cache
25 19 0:15 / /var/btrfs rw,noatime,nodiratime - btrfs /dev/sdc3
rw,space_cache


If I do:

$ #test 1
$ sudo ./btrfs su show /

I got nothing

If I do

$ #test 2
$ sudo ./btrfs su show /var/btrfs/

still, I got nothing

$ #test 3
$  sudo ./btrfs su show /var/btrfs/__active

I, finally, got:

/var/btrfs/__active
	uuid: 			835c96b8-c066-554b-9230-1c531e831ff6
	Parent uuid: 		-
	Creation time: 		-
	Object ID: 		256
	Generation (Gen): 	75774
	Gen at creation: 	0
	Parent: 		5
	Top Level: 		5
	Snapshot(s):


I expected also from test1 and test2 something.

BR
G.Baroncelli





-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
