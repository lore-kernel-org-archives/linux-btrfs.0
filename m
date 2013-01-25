Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:51306 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AYPLB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:11:01 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130125151100.HLAO2891.eastrmfepo101.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 25 Jan 2013 10:11:00 -0500
Message-ID: <5102A083.8090006@czarc.net>
Date: Fri, 25 Jan 2013 10:10:59 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <51029EFB.90301@czarc.net>
In-Reply-To: <51029EFB.90301@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/25/2013 10:04 AM, Gene Czarcinski wrote:
> OK, I think I have gotten the message that this is a bad idea as 
> implemented and that it should be dropped as such.  I believe that 
> there are some things ("btrfs fi show" comes to mind) which will need 
> root and I am going to explore doing something for that case.  And it 
> also might be reasonable for some situations to issue the message 
> about root if something errors-out.
>
> Anyway, this approach is dead and I will continue to give this some 
> thought.
>
> Comments?
>
> Gene
>
>
>
> On 01/25/2013 06:32 AM, Gene Czarcinski wrote:
>> This patch hits a lot of files but adds little code.  It
>> could be considered a bugfix,  Currently, when one of the
>> btrfs user-space programs is executed by a regular user,
>> the result if oftem a number of strange error messages
>> which do not indicate the real problem.  This patch changes
>> that situation.
>>
>> A test is performed as to whether the program is running
>> as root.  If it is not, issue an error message and exit.
>> Signed-off-by: Gene Czarcinski<gene@czarc.net>
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
>
BTW, I want to thank all of you who commented.  I have seen far too many 
submitted patches land with a thump and nothing more ... no comments ... 
either good or bad.

Gene
