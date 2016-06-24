Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35193 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbcFXRvC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:51:02 -0400
Received: by mail-io0-f173.google.com with SMTP id f30so105409515ioj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:51:01 -0700 (PDT)
Subject: Re: Trying to rescue my data :(
To: Steven Haigh <netwiz@crc.id.au>, linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
Date: Fri, 24 Jun 2016 13:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-24 13:43, Steven Haigh wrote:
> On 25/06/16 03:40, Austin S. Hemmelgarn wrote:
>> On 2016-06-24 13:05, Steven Haigh wrote:
>>> On 25/06/16 02:59, ronnie sahlberg wrote:
>>> What I have in mind here is that a file seems to get CREATED when I copy
>>> the file that crashes the system in the target directory. I'm thinking
>>> if I 'cp -an source/ target/' that it will make this somewhat easier (it
>>> won't overwrite the zero byte file).
>> You may want to try with rsync (rsync -vahogSHAXOP should get just about
>> everything possible out of the filesystem except for some security
>> attributes (stuff like SELinux context), and will give you nice
>> information about progress as well).  It will keep running in the face
>> of individual read errors, and will only try each file once.  It also
>> has the advantage of showing you the transfer rate and exactly where in
>> the directory structure you are, and handles partial copies sanely too
>> (it's more reliable restarting an rsync transfer than a cp one that got
>> interrupted part way through).
>
> I may try that - I came up with this:
> #!/bin/bash
>
> mount -o ro,nossd,degraded /dev/xvdc /mnt/fileshare/
>
> find /mnt/fileshare/data/Photos/ -type f -print0 |
>     while IFS= read -r -d $'\0' line; do
>         echo "Processing $line"
>         DIR=`dirname "$line"`
>         mkdir -p "/mnt/recover/$DIR"
>         if [ ! -e "/mnt/recover/$line" ]; then
>                 echo "Copying $line to /mnt/recover/$line"
>                 touch "/mnt/recover/$line"
>                 sync
>                 cp -f "$line" "/mnt/recover/$line"
>                 sync
>         fi
>     done
>
> umount /mnt/fileshare
>
> I'm slowly picking through the data - and it has crashed a few times...
> It seems that there are some checksum failures that don't crash the
> entire system - so that's a good thing to know - not sure if that means
> that it is correcting the data with parity - or something else.
>
> I'll see how much data I can extract with this and go from there - as it
> may be good enough to call it a success.
>
AH, if you're having issues with crashes when you hit errors, you may 
want to avoid rsync then, it will try to reread any files that don't 
match in size and mtime, so it would likely just keep crashing on the 
same file over and over again.

Also, looking at the script you've got, that will probably run faster 
too because it shouldn't need to call stat() on everything like rsync 
does (because of the size and mtime comparison).
