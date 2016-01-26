Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:41715 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbcAZIy7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 03:54:59 -0500
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Chris Murphy <lists@colorremedies.com>
References: <56A230C3.3080100@netcologne.de>
 <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
 <56A6082C.3030007@netcologne.de>
 <CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
 <CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
 <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
 <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
 <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56A73460.7080100@netcologne.de>
Date: Tue, 26 Jan 2016 09:54:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris and all,

On 01/25/2016 11:13 PM, Chris Murphy wrote:
> Does anyone suspect a kernel regression here? I wonder if its worth it
> to suggest testing the current version of all fairly recent kernels:
> 4.5.rc1, 4.4, 4.3.4, 4.2.8, 4.1.16? I think going farther back to
> 3.18.x isn't worth it since that's before the major work since raid56
> was added. Quite a while ago I've done a raid56 rebuild and balance
> that was pretty fast but it was only a 4 or 5 device test.

Problem is that this balance did not work before going to 4.4 kernel,
it's was simply crashing after about an hour or two of runtime.

Currently I am using 4.4 kernel + btrfs-progs, so apart from 4.5rc1 I
can not get any more bleeding edge.

4.5 I am happy to try, but not RC1 as there are already some bugs
popping up regarding the BTRFS changes.


On 01/26/2016 07:14 AM, Chris Murphy wrote:
> Christian, what are you getting for 'iotop -d3 -o' or 'iostat -d3'. Is
> it consistent or is it fluctuating all over the place? What sort of
> eyeball avg/min/max are you getting?

"1672.81 K/s 1672.81 K/s  0.00 %  6.99 % btrfs balance start -dstripes
1..11 -mstripes 1..11 "

but it's jumping up to 25MB/s for a few polls, but most of the time it's
at 1.3 to 1.7 MB/s


You may check out more the various munin graphs of the box if you like:
 * http://mirror.netcologne.de/munin

has all the goods.
This also brings me to mention, that the disks (it's 12 disks though!)
read somewhere between 20 and 60MB/s constantly.




Regards

Christian




