Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:46197 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbbJEPII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 11:08:08 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	by mail.digint.ch (Postfix) with ESMTPSA id 97D0E2F70056
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2015 17:08:06 +0200 (CEST)
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
 <560FA944.3050606@digint.ch> <5610134D.9070807@inwind.it>
 <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net> <561138F4.5090105@inwind.it>
Cc: linux-btrfs@vger.kernel.org
From: Axel Burri <axel@tty0.ch>
Message-ID: <56129280.1010800@tty0.ch>
Date: Mon, 5 Oct 2015 17:08:48 +0200
MIME-Version: 1.0
In-Reply-To: <561138F4.5090105@inwind.it>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2015-10-04 16:34, Goffredo Baroncelli wrote:
> On 2015-10-04 05:37, Duncan wrote:
>> Goffredo Baroncelli posted on Sat, 03 Oct 2015 19:41:33 +0200 as
>> excerpted:
>>
>>> On 2015-10-03 12:09, Axel Burri wrote:
>>>>
>>>>
>>>> On 2015-10-03 11:56, Goffredo Baroncelli wrote:
>>>>> On 2015-10-02 18:41, axel@tty0.ch wrote:
>>>>>> Old implementation used tabs "\t", and tried to work around problems
>>>>>> by guessing amount of tabs needed (e.g. "\t\t" after top level", with
>>>>>> buggy output as soon as empty uuids are printed). This will never
>>>>>> work correctly, as tab width is a user-defined setting in the
>>>>>> terminal.
>>>>>
>>>>>
>>>>> Why not use string_table() and table_*() functions  ?
>>>>
>>>> string_table(), as well as all table functions by nature, needs to know
>>>> the maximum size of all cells in a row before printing, and therefore
>>>> buffers all the output before printing. It would eat up a lot of memory
>>>> for large tables (it is not unusual to have 1000+ subvolumes in btrfs
>>>> if you make heavy use of snapshotting). Furthermore, it would slow down
>>>> things by not printing the output linewise.
>>>
>>>
>>> Assuming 200bytes per row (== subvolume) x 1000 subvolumes = 200kB... I
>>> don't think that this could be a problem, nor in terms of memory used
>>> nor in terms of speed: if you have 1000+ subvolumes the most time
>>> consuming activity is traversing the filesystem looking at the
>>> snapshot...
>>
>> Perhaps unfortunately, scaling to millions of snapshots/subvolumes really 
>> *is* expected by some people.  You'd be surprised at the number of folks 
>> that setup automated per-minute snapshotting with no automated thinning, 
>> and expect to be able to keep several years' worth of snapshots, and then 
>> wonder why btrfs maintenance commands such as balance take weeks/months...
> [...]
>> Obviously btrfs doesn't scale to that level now, and if it did, someone 
>> making the mistake of trying to get a listing of millions of snapshots 
>> would very likely change their mind before even hitting 10%...
>>
>> But that's why actually processing line-by-line is important, so they'll 
>> actually /see/ what happened and ctrl-C it, instead of the program 
>> aborting as it runs into (for example) the 32-bit user/kernel memory 
>> barrier, without printing anything useful...
> 
> Please Ducan, read the code.
> 
> *TODAY* "btrfs list" does a scan of all subvolumes storing information in memory !
> 
> This is the most time consuming activity (think traversing a filesystem with millions of snapshots)
> 
> *Then* "btrfs list" print the info.
> 
> So you are already blocked at the screen until all subvolume are read. And I repeat (re)processing the information requires less time than reading the information from the disk.
> 
> [....]
> 

A quick look at the code shows me that Goffredo is right here, as
__list_subvol_search() always fetches ALL data from
BTRFS_IOC_TREE_SEARCH, putting it into a rbtree for later processing
(assemble full paths, sorting).

While there is certainly room for improvements here (assuming that
BTRFS_IOC_TREE_SEARCH returns objectid's in sorted order, it would
definitively be possible to produce line-by-line output), the code looks
pretty elegant the way it is.

I still don't think it is wise to bloat things further just for printing
nice tables. My impression is that "btrfs subvolume list" is
human-readable enough without the '-t' flag, while the output with '-t'
flag is much more machine-readable-friendly, and thus should have the
highest possible performance. e.g.:

  btrfs sub list  -t / | (read th; while read $th ; do echo $gen; done)
  btrfs sub list -t | column -t

Again, this is just my opinion, being a "unix-purist". Maybe a good
compromise would be to use a single "\t" instead of " " as column delimiter.
