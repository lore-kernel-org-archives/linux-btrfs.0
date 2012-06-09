Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:47581 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab2FIFgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jun 2012 01:36:24 -0400
Message-ID: <4FD2E0D7.9000101@libero.it>
Date: Sat, 09 Jun 2012 07:36:23 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 3/3] Add btrfs filesystem info man page.
References: <1339182766-15292-1-git-send-email-kreijack@inwind.it> <1339182766-15292-4-git-send-email-kreijack@inwind.it> <CALJXSJo9nqC+ybB7bk0dZv12mg=NMG4Oiv52Y02yxCUcek1=_A@mail.gmail.com>
In-Reply-To: <CALJXSJo9nqC+ybB7bk0dZv12mg=NMG4Oiv52Y02yxCUcek1=_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2012 09:21 PM, Jérôme Poulin wrote:
> What kind of "info" does it give? This is really unhelpful in a man
> page, it just tells the obvious.

Definitely, this is one of the point of this patch to improve.

> 
> On Fri, Jun 8, 2012 at 3:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>>
>> Update the man page to document the "btrfs filesystem info <path>"
>> command.
>> ---
>>  man/btrfs.8.in |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
>> index be478e0..6d96bf7 100644
>> --- a/man/btrfs.8.in
>> +++ b/man/btrfs.8.in
>> @@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
>>  .PP
>>  \fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
>>  .PP
>> +\fBbtrfs\fP \fBfilesystem info\fP\fI <path>\fP
>> +.PP
>>  \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
>>  .PP
>>  \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
>> @@ -154,6 +156,12 @@ The start position and the number of bytes to deframention can be specified by \
>>  NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't
>>  use it if you use snapshots, have de-duplicated your data or made copies with
>>  \fBcp --reflink\fP.
>> +.TP
>> +
>> +\fBfilesystem info\fP \fI<path>\fR
>> +Get filesystem info.
>> +.TP
>> +
>>  \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
>>  List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
>>  .TP
>> --
>> 1.7.10
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

