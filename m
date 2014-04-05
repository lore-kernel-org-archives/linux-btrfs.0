Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53169 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaDEWA1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 18:00:27 -0400
Received: by mail-ig0-f180.google.com with SMTP id c1so2268198igq.1
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 15:00:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140404184620.GA12124@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
	<20140404184620.GA12124@merlins.org>
Date: Sat, 5 Apr 2014 16:00:27 -0600
Message-ID: <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
From: cwillu <cwillu@cwillu.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 4, 2014 at 12:46 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Apr 02, 2014 at 04:29:35PM +0800, Qu Wenruo wrote:
>> Convert man page for btrfs-zero-log
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  Documentation/Makefile           |  2 +-
>>  Documentation/btrfs-zero-log.txt | 39 +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 40 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/btrfs-zero-log.txt
>>
>> diff --git a/Documentation/Makefile b/Documentation/Makefile
>> index e002d53..de06629 100644
>> --- a/Documentation/Makefile
>> +++ b/Documentation/Makefile
>> @@ -11,7 +11,7 @@ MAN8_TXT += btrfs-image.txt
>>  MAN8_TXT += btrfs-map-logical.txt
>>  MAN8_TXT += btrfs-show-super.txt
>>  MAN8_TXT += btrfstune.txt
>> -#MAN8_TXT += btrfs-zero-log.txt
>> +MAN8_TXT += btrfs-zero-log.txt
>>  #MAN8_TXT += fsck.btrfs.txt
>>  #MAN8_TXT += mkfs.btrfs.txt
>>
>> diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
>> new file mode 100644
>> index 0000000..e3041fa
>> --- /dev/null
>> +++ b/Documentation/btrfs-zero-log.txt
>> @@ -0,0 +1,39 @@
>> +btrfs-zero-log(8)
>> +=================
>> +
>> +NAME
>> +----
>> +btrfs-zero-log - clear out log tree
>> +
>> +SYNOPSIS
>> +--------
>> +'btrfs-zero-log' <dev>
>> +
>> +DESCRIPTION
>> +-----------
>> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
>> +allow you to mount the filesystem again.
>> +
>> +The common case where this happens has been fixed a long time ago,
>> +so it is unlikely that you will see this particular problem.
>
> A note on this one: this can happen if your SSD rites things in the
> wrong order or potentially writes garbage when power is lost, or before
> locking up.
> I hit this problem about 10 times and it wasn't a btrfs bug, just the
> drive doing bad things.

And -o recovery didn't work around it?  My understanding is that -o
recovery will skip reading the log.
