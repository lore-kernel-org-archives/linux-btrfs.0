Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp38.i.mail.ru ([94.100.177.98]:44771 "EHLO smtp38.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbcGDXP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 19:15:56 -0400
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:45968 helo=centurion.home)
	by smtp38.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bKD5l-0007Hr-IQ
	for linux-btrfs@vger.kernel.org; Tue, 05 Jul 2016 02:15:54 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion.home (Postfix) with ESMTPSA id 01BB02582D5
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 01:15:49 +0200 (CEST)
Subject: Re: btrfs defrag questions
References: <5776CF08.5040601@mail.ru>
 <CAPmG0jaDczRh3wLULW17pNSxKHnCPY0A3UxchsDy5C=xHH8XCQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <577AEE25.9000704@mail.ru>
Date: Tue, 5 Jul 2016 01:15:49 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jaDczRh3wLULW17pNSxKHnCPY0A3UxchsDy5C=xHH8XCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-01 22:46, Henk Slager wrote:
> (email ends up in gmail spamfolder)
> On Fri, Jul 1, 2016 at 10:14 PM, Dmitry Katsubo <dma_k@mail.ru> wrote:
>> Hello everyone,
>>
>> Question #1:
>>
>> While doing defrag I got the following message:
>>
>> # btrfs fi defrag -r /home
>> ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
>> total 1 failures
>>
>> I feel that something went wrong, but the message is a bit misleading.
>>
>> Provided that Dropbox is running in the system, does it mean that it
>> cannot be defagmented?
> 
> I think it is a matter of newlines in btrfs-progs and/or stdout/stderr mixup.
> 
> You should run the command with -v and probably also with -f, so that
> it gets hopefully clearer what is wrong.

Running with "-v -f" (or just "-v") result the same output:

...
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/select.so
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/grp.so
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/posixffi.libc._posixffi_libcERROR: defrag failed on /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox: Success
.so
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/_functools.so
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox
/home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/_csv.so
...

This is not a matter of newlines:

$ grep -rnH 'defrag failed' btrfs-progs
btrfs-progs/cmds-filesystem.c:1021:       error("defrag failed on %s: %s", fpath, strerror(e));
btrfs-progs/cmds-filesystem.c:1161:                       error("defrag failed on %s: %s", argv[i], strerror(e));

> That it fails on dropbox is an error I think, but maybe known: Could
> be mount option is compress and that that causes trouble for defrag
> although that should not happen.

True, compression is enabled.

> You can defrag just 1 file, so maybe you could try to make a reproducible case.

When I run it on one file, it works as expected:

# btrfs fi defrag -r -v /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox
ERROR: cannot open /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox: Text file busy

> What kernel?
> What btrfs-progs?

kernel v4.4.6
btrfs-tools v4.5.2

>> Question #2:
>>
>> Suppose that in above example /home/ftp is mounted as another btrfs
>> array (not subvolume). Will 'btrfs fi defrag -r /home' defragment it
>> (recursively) as well?
> 
> I dont know, I dont think so, but you can simply try.
 
Many thanks, now I see how can I check this. Unfortunately it does not
descend into submounted directories.

-- 
With best regards,
Dmitry
