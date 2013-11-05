Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:38058 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3KESxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 13:53:49 -0500
Message-ID: <52793EB5.7050808@complete.org>
Date: Tue, 05 Nov 2013 12:53:41 -0600
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: umount waiting for 12 hours and still running
References: <20131106034622.5209f127@virtall.com>
In-Reply-To: <20131106034622.5209f127@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/05/2013 12:46 PM, Tomasz Chmielewski wrote:
>> More than 12 hours ago, I tried to umount a btrfs filesystem.
>> Something involving btrfs-cleaner and btrfs-transacti is still
>> running, but I don't know what.
>
> Does "iostat -x 1" or "iostat -k 1" show any disk activity?

Yes.  For instance, from iostat -x 1:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc               0.00     0.00  104.00    0.00   416.00     0.00 
8.00     1.03   10.08   10.08    0.00   9.31  96.80
sdd               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00

sdc and sdd are the drives in this brtfs FS, and they are used for 
nothing but that.

iostat -k 1 shows similar levels of activity.

>
> Anything interesting in dmesg?

There was this when it was first mounted:

Nov  4 11:28:43 erwin kernel: [  200.669110] btrfs: use lzo compression
Nov  4 11:28:43 erwin kernel: [  200.669114] btrfs: disk space caching 
is enabled
Nov  4 11:28:58 erwin kernel: [  215.660695] BTRFS debug (device dm-15): 
unlinked 1 orphans
Nov  4 11:28:58 erwin kernel: [  215.673535] btrfs: force skipping balance

I later canceled the balance

Also, several like this:

Nov  4 11:51:23 erwin kernel: [ 1560.552129] INFO: task 
btrfs-transacti:6775 blocked for more than 120 seconds.
Nov  4 11:51:23 erwin kernel: [ 1560.552200] btrfs-transacti D 90d3d4a2 
     0  6775      2 0x00000000
Nov  4 11:51:23 erwin kernel: [ 1560.553136]  [<f85852b6>] ? 
wait_current_trans.isra.20+0x8b/0xb5 [btrfs]
Nov  4 11:51:23 erwin kernel: [ 1560.553217]  [<f858740d>] ? 
start_transaction+0x1db/0x46f [btrfs]
Nov  4 11:51:23 erwin kernel: [ 1560.553267]  [<f85876e0>] ? 
btrfs_attach_transaction+0xd/0x10 [btrfs]
Nov  4 11:51:23 erwin kernel: [ 1560.553316]  [<f8580963>] ? 
transaction_kthread+0xa3/0x158 [btrfs]
Nov  4 11:51:23 erwin kernel: [ 1560.553366]  [<f85808c0>] ? 
try_to_freeze+0x28/0x28 [btrfs]

but that was befrore the umount.

Nothing else.

-- John

>
>
