Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:44727 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbbJDOec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Oct 2015 10:34:32 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
 <560FA944.3050606@digint.ch> <5610134D.9070807@inwind.it>
 <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <561138F4.5090105@inwind.it>
Date: Sun, 4 Oct 2015 16:34:28 +0200
MIME-Version: 1.0
In-Reply-To: <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-10-04 05:37, Duncan wrote:
> Goffredo Baroncelli posted on Sat, 03 Oct 2015 19:41:33 +0200 as
> excerpted:
> 
>> On 2015-10-03 12:09, Axel Burri wrote:
>>>
>>>
>>> On 2015-10-03 11:56, Goffredo Baroncelli wrote:
>>>> On 2015-10-02 18:41, axel@tty0.ch wrote:
>>>>> Old implementation used tabs "\t", and tried to work around problems
>>>>> by guessing amount of tabs needed (e.g. "\t\t" after top level", with
>>>>> buggy output as soon as empty uuids are printed). This will never
>>>>> work correctly, as tab width is a user-defined setting in the
>>>>> terminal.
>>>>
>>>>
>>>> Why not use string_table() and table_*() functions  ?
>>>
>>> string_table(), as well as all table functions by nature, needs to know
>>> the maximum size of all cells in a row before printing, and therefore
>>> buffers all the output before printing. It would eat up a lot of memory
>>> for large tables (it is not unusual to have 1000+ subvolumes in btrfs
>>> if you make heavy use of snapshotting). Furthermore, it would slow down
>>> things by not printing the output linewise.
>>
>>
>> Assuming 200bytes per row (== subvolume) x 1000 subvolumes = 200kB... I
>> don't think that this could be a problem, nor in terms of memory used
>> nor in terms of speed: if you have 1000+ subvolumes the most time
>> consuming activity is traversing the filesystem looking at the
>> snapshot...
> 
> Perhaps unfortunately, scaling to millions of snapshots/subvolumes really 
> *is* expected by some people.  You'd be surprised at the number of folks 
> that setup automated per-minute snapshotting with no automated thinning, 
> and expect to be able to keep several years' worth of snapshots, and then 
> wonder why btrfs maintenance commands such as balance take weeks/months...
[...]
> Obviously btrfs doesn't scale to that level now, and if it did, someone 
> making the mistake of trying to get a listing of millions of snapshots 
> would very likely change their mind before even hitting 10%...
> 
> But that's why actually processing line-by-line is important, so they'll 
> actually /see/ what happened and ctrl-C it, instead of the program 
> aborting as it runs into (for example) the 32-bit user/kernel memory 
> barrier, without printing anything useful...

Please Ducan, read the code.

*TODAY* "btrfs list" does a scan of all subvolumes storing information in memory !

This is the most time consuming activity (think traversing a filesystem with millions of snapshots)

*Then* "btrfs list" print the info.

So you are already blocked at the screen until all subvolume are read. And I repeat (re)processing the information requires less time than reading the information from the disk.

[....]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
