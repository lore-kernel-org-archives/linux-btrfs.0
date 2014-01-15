Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51582 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751959AbaAORIB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 12:08:01 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:57835 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3Twa-003ESD-K8
	for linux-btrfs@vger.kernel.org; Wed, 15 Jan 2014 10:07:58 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck failes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140115151545.GI10639@merlins.org>
Date: Wed, 15 Jan 2014 10:07:57 -0700
Message-Id: <7E76D03B-A13E-4192-8CA5-7AEE0D9BE48D@colorremedies.com>
References: <CAFP7zVtDEfDjKA1GvBq_QMs6gKv9t=K_qNyv6dcxawe5iuj8Kw@mail.gmail.com> <D942F4C1-471E-476F-BEC1-3090DDAEB115@colorremedies.com> <CAFP7zVuB=A2Lty275-VdixjzG6twXKmJo0qB3gZEH=9noQbpRQ@mail.gmail.com> <CAFP7zVvk_cXfCrdie9CqGpAa2y6=t4L4bn93v3kNJdudH5nDhw@mail.gmail.com> <20140115151545.GI10639@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 15, 2014, at 8:15 AM, Marc MERLIN <marc@merlins.org> wrote:

> On Wed, Jan 15, 2014 at 08:53:55AM +0100, Holger Brandsmeier wrote:
>> # btrfs-zero-log /dev/sda5
>> parent transid verify failed on 602529792 wanted 23460 found 23463
>> parent transid verify failed on 602529792 wanted 23460 found 23463
>> parent transid verify failed on 602529792 wanted 23460 found 23463
>> parent transid verify failed on 602529792 wanted 23460 found 23463
>> Ignoring transid failure
>> btrfs-zero-log: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
>> Aborted (core dumped)
> 
> I've been seeing this quite a bit too. Is this fixed already, or known
> broken?
> 
> I can run under gdb next time if needed.

I don't know. That alone might be worth a bz on kernel.org. If you do I'd also put the URL in this thread. And then also try building btrfs-progs from the integration branch, and seeing if it's still reproducible and include that information in the bug as well.


> # btrfs-image -c9 -t4 /dev/sda5 /some/path
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> Ignoring transid failure
> Error going to next leaf -5
> create failed (Success)
> 
> means this failed or succeeded, it wrote a file which is 1.3mb large.

That last message is confusing. I'd say failed because your metadata allocation was much bigger than 1.3MB. If you build new progs from integration branch it might be worth filing this as a separate bug from recovery/repair attempt bug.


> The two files differ, but to me they both look equally bad. Should I
> try `btrfs-select-super` or `btrfsck --repair --init-extent-tree` /
> `btrfsck --repair --init-csum-tree`.

Archives contain some information on the consequences of those options. I'm pretty sure even if they work enough to let you mount the file system (to grab a more recent backup) that you will need to start over with a new file system. Before you do that I would file a bug for what you've done thus far, with the description being everything you've done, in order, up to this point. What kernel, what progs, that you started with btrfsck --repair, etc. The smartctl output as an attachment, and the dmesg you posted earlier showing the (likely) metadata repair after the read error.

Then upgrade to kernel 3.13rc8 because I can't tell you if any Btrfs changes since 3.12.7 will fix this problem or not and chances are it will be asked anyway. Retry mounting normally, then with -o recovery, -o ro,recovery and report on those results in the bug. Include user spaces messages and dmesg.

If that doesn't work, I would build btrfs-progs from integration branch and try the user space options in the order in Hugo's email. And report those results in the bug. If you get the btrfs-zero-log crash that's probably worth a separate gdb attachment before going on to anything btrfs repair (btrfsck) related.


At any time before btrfs repair you can bail out, include right now, with btrfs restore.
https://btrfs.wiki.kernel.org/index.php/Restore

Grab what you can, and then blow away the file system. But I think you might have an interesting case because something this broken is inherently valuable, especially if it was btrfs repair that made it worse.

Chris Murphy

