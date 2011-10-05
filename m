From: Jim <jim@webstarts.com>
Subject: Re: too many files open
Date: Wed, 05 Oct 2011 11:54:35 -0400
Message-ID: <4E8C7DBB.20901@webstarts.com>
References: <4E8C76AB.6080401@webstarts.com> <20111005213119.3672fdd9@natsu> <4E8C7885.50205@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Roman Mamedov <rm@romanrm.ru>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8C7885.50205@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

Checked ulimit and processes are not the issue here.  Rsync never has 
more than 15 instances running and even accounting for children and 
other processes they wouldnt approach the process limit.  The error 
ddoes seem to be with btrfs as I cant ls the file system while this 
condition exists.  Ls also returns "too many files open".  Btrfs sub 
list also shows the same too many files open condition.  Actually, there 
should be no files open after the script has failed (the script runs, 
just reports the errors).  Something either reports files as being open 
or is holding them open, and a remount flushes this and the fs is back 
to normal.  Very confusing.
Jim

On 10/05/2011 11:32 AM, Jim wrote:
> Thanks very much for the idea.  I will check and get back.
> Jim
>
>
> On 10/05/2011 11:31 AM, Roman Mamedov wrote:
>> On Wed, 05 Oct 2011 11:24:27 -0400
>> Jim<jim@webstarts.com>  wrote:
>>
>>> Good morning Btrfs list,
>>> I have been loading a btrfs file system via a script rsyncing data 
>>> files
>>> from an nfs mounted directory.  The script runs well but after several
>>> days (moving about 10TB) rsync reports that it is sending the file list
>>> but stops moving data because btrfs balks saying too many files 
>>> open.  A
>>> simple umount/mount fixes the problem.  What am I flushing when I
>>> remount that would affect this, and is there a way to do this without a
>>> remount.  Once again thanks for any assistance.
>> Are you sure it's a btrfs problem? Check "ulimit -n", see "help 
>> ulimit" (assuming you use bash).
>>
