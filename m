Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34025 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbcFQWSy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 18:18:54 -0400
Received: by mail-oi0-f44.google.com with SMTP id d132so136731966oig.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 15:18:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca>
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
	<CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
	<25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca>
Date: Fri, 17 Jun 2016 16:18:53 -0600
Message-ID: <CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
Subject: Re: Scrub aborts on newer kernels
From: Chris Murphy <lists@colorremedies.com>
To: Tyson Whitehead <twhitehead@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 8:45 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
> On May 27, 2016 12:12:54 PM Chris Murphy wrote:
>> On Thu, May 26, 2016 at 11:55 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
>> > Under the last several kernels versions (4.6 and I believe 4.4 and, 4.5) btrfs scrub aborts before completing.
>>
>> I can't reproduce this with btrfs-progs 4.5.2 and kernel 4.6.0.
>>
>> I think the bigger issue is the lack of information why a scrub is aborted.
>
> Thanks for checking into this Chris.
>
> Any advice on how to get some more information out of the scrub process?

So I can't help you out with why scrub fails. That sounds like a bug,
not least of which is there's no information why it's failing. So I
suggest filing a bug with what you know to date and include in this
thread for reference. The main point is that there *are* errors (a lot
of them apparently) needing fixing up, but somehow certain kernel
versions are aborting and there's no information why.

Next you need to find out why this one device has so many errors. Put
the output from smartctl -x /dev/sdb somewhere, maybe even attach it
to the bug report since it's somewhat related. Either that device is
simply unreliable, or you've got a bad cable connection.

You need to include an entire dmesg, or even better would be dmesg and
also 'journalctl -b -o short-monotonic' attached to the bug report
also. While there may be no btrfs messages indicating what's going on,
there might be usb or libata message indicating hardware problems that
are instigating.



-- 
Chris Murphy
