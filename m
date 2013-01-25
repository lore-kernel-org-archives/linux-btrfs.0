Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:47259 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AYM3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 07:29:46 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130125122945.DKKM17456.eastrmfepo201.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 25 Jan 2013 07:29:45 -0500
Message-ID: <51027AB8.6030901@czarc.net>
Date: Fri, 25 Jan 2013 07:29:44 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <20130125175530.75402fb5@natsu>
In-Reply-To: <20130125175530.75402fb5@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/25/2013 06:55 AM, Roman Mamedov wrote:
> On Fri, 25 Jan 2013 06:32:30 -0500
> Gene Czarcinski <gene@czarc.net> wrote:
>
>> This patch hits a lot of files but adds little code.  It
>> could be considered a bugfix,  Currently, when one of the
>> btrfs user-space programs is executed by a regular user,
>> the result if oftem a number of strange error messages
>> which do not indicate the real problem.  This patch changes
>> that situation.
>>
>> A test is performed as to whether the program is running
>> as root.  If it is not, issue an error message and exit.
>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> $ ls -la /dev/sda
> brw-rw---T 1 root disk 8, 0 Jan 15 12:11 /dev/sda
>
> The user does not have to be root, they can be a member of the group "disk" to
> manage this device.
>
> Also some or all of the tools accept not just a block device, but also a
> regular file as their parameter.
>
> Wouldn't it be better to check whether or not the running user has
> *write access* to the device or file to be operated on, before failing?
I knew there would be corner cases where root was not required for 
execution.  After all, I do not need to be root to execute "btrfs 
--version".  Now, is it worth the effort to determine the corner cases 
and do you have a proposed solution as to determining what privileges 
are needed when?  I can understand when it could be a regular file but 
is it all that common for users to be part of group disk?

If there is a case where it is difficult to figure out if root is 
needed, then my solution would be to turn it into a warning message and 
remove the exit for that specific program.

However, I believe the real answer is to use sudo.

Gene
>
>> ---
>>   btrfs-corrupt-block.c | 5 +++++
>>   btrfs-image.c         | 5 +++++
>>   btrfs-map-logical.c   | 5 +++++
>>   btrfs-select-super.c  | 5 +++++
>>   btrfs-show-super.c    | 5 +++++
>>   btrfs-show.c          | 5 +++++
>>   btrfs-vol.c           | 5 +++++
>>   btrfs-zero-log.c      | 5 +++++
>>   btrfs.c               | 6 ++++++
>>   btrfsck.c             | 5 +++++
>>   btrfsctl.c            | 5 +++++
>>   btrfstune.c           | 5 +++++
>>   calc-size.c           | 5 +++++
>>   convert.c             | 6 ++++++
>>   debug-tree.c          | 5 +++++
>>   dir-test.c            | 5 +++++
>>   find-root.c           | 5 +++++
>>   ioctl-test.c          | 6 ++++++
>>   mkfs.c                | 5 +++++
>>   quick-test.c          | 6 ++++++
>>   restore.c             | 5 +++++
>>   21 files changed, 109 insertions(+)

