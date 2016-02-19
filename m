Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36184 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427685AbcBSQm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 11:42:29 -0500
Received: by mail-ig0-f182.google.com with SMTP id xg9so38695747igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Feb 2016 08:42:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C73C09.3080207@netcologne.de>
References: <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
	<20160211191741.GA4762@localhost.localdomain>
	<CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
	<20160212032226.GA10542@localhost.localdomain>
	<CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
	<20160212203426.GA24399@localhost.localdomain>
	<CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
	<20160214213224.GB28882@localhost.localdomain>
	<20160215034219.2f0df0ce@natsu>
	<56C5BA8C.1020106@netcologne.de>
	<20160218165943.GB2492@localhost.localdomain>
	<56C73C09.3080207@netcologne.de>
Date: Fri, 19 Feb 2016 09:42:28 -0700
Message-ID: <CAJCQCtTue8ud1G0-WJpmmba0F5Us=Wjze5ZD9aEJsqzUjFhpuQ@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bo.li.liu@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 19, 2016 at 9:00 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hey liubo,
>
> thanks for the quick response.
>
> On 02/18/2016 05:59 PM, Liu Bo wrote:
>>> Apparently also with 4.4 there is some sort of blocking happening ...
>>> > just at 38580:
>> OK, what does 'sysrq-w' say?
>
> The problem has not appeared again for some time. Do I need to catch it
> right when it happens? If so, what evidence should I collect and how?

It's uncertain how your kernel is built so full documentation is here:
https://www.kernel.org/doc/Documentation/sysrq.txt

Anytime before or during the problem:
echo 1 >/proc/sys/kernel/sysrq

Once blocked tasks show up:
echo w > /proc/sysrq-trigger

journalctl -k -o short-monotonic -l > journal_sysrqw.txt    ## example

If you're not on a systemd system, all of this should get dumped into
rsyslogd messages, so you can go in there and extract the current boot
into a file to attach. It should also appear in dmesg of course but
sometimes the output is bigger than the default kernel message buffer.

-- 
Chris Murphy
