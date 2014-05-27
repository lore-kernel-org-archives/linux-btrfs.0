Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52862 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaE0TGx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 15:06:53 -0400
Message-ID: <5384E2FA.1070509@fb.com>
Date: Tue, 27 May 2014 15:09:46 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
References: <5384D53C.9070509@skagestad.org>
In-Reply-To: <5384D53C.9070509@skagestad.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/27/2014 02:11 PM, Torbjørn wrote:
> Hi,
> 
> Btrfs-transaction keeps blocking for me on all 3.15-rc versions.
> 3.14 does not have this issue.
> The process never gets unstuck. btrfs fi sync does not help. A hard
> reboot seems to be the only way to recover.
> 
> The volume is still readable when it's in this state.
> 
> dmesg + sysrq-w is available at
> https://urldefense.proofpoint.com/v1/url?u=http://pastebin.com/vHQnRE2F&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=IKSs%2F0C3x9a0LIiVKFmZVoP9lSAZ%2BK9JgEkchLEAAzM%3D%0A&s=127b40cc34dbb205b5277e6081b082f26e84fc417d35310f3aeee04998a679a8
> 
> It's over 6000 lines, and would most likely not be allowed on the list.
> 
> The blocking happons on a server with local kvm-clients reading and
> writing to a local btrfs-volume over nfs.
> The btrfs-volume is on top of dm-crypt devices.
> 
> Any additional info I can give to help?
> Tests you want me to run?

Very strange, since I don't actually see what we're waiting for.  Can
you please either send me your btrfs.ko or use gdb to see where this
statement is:


btrfs_commit_transaction+0x315

The syntax is

gdb btrfs.ko
gdb> list *btrfs_commit_transaction+0x315

-chris
