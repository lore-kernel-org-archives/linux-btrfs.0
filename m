Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:46162 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758894AbdKQPUk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:20:40 -0500
Received: by mail-pg0-f51.google.com with SMTP id z184so2159126pgd.13
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 07:20:40 -0800 (PST)
Subject: Re: Btrfs restore error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>
 <ad8010db-9e11-e205-d77a-d15a11b4da56@gmx.com>
From: Jay <j4y0t15@gmail.com>
Message-ID: <eb425021-1b72-cc69-559f-e3d21bcc52b0@gmail.com>
Date: Fri, 17 Nov 2017 08:20:37 -0700
MIME-Version: 1.0
In-Reply-To: <ad8010db-9e11-e205-d77a-d15a11b4da56@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017-11-16 10:38 PM, Qu Wenruo wrote:
> 
> 
> On 2017年11月17日 11:56, Jay wrote:
>> Hello,
>>
>> I thought I should report something since there was little information
>> on this error. The situation is I have 2 external hard drives on
>> Xubuntu. One is not working and I need to move the data over to the
>> other.
> 
> "btrfs replace" should be your first option, not "btrfs restore", unless
> it's totally damaged and you want to salvage as much as possible.

OK, thank you.

>> I used 'sudo btrfs restore -v /dev/sde1 /mnt/Old4TB' and
>> received 'Error mkdiring /mnt/Old4TB/Jayda TV:2'.
> 
> No extra info like something restored succefully? Just 'Error mkdiring
> /mnt/Old4TB/Jayda TV:2'?

Correct, the program just exited.

> At least it's ENOENT, checking mkdir(3p) should gives your the reason:
> ---
>         ENOENT A  component  of the path prefix specified by path does
> not name
>                an existing directory or path is an empty string.
> 
> ---
> 
> Did the dir "/mnt/Old4TB" exists in first place?

I see, errno was set to 2; ENOENT.  Thank you. Yes, Old4TB is a drive 
that is auto mounted on boot to that permanent mount point.  I was able 
to create a folder on that drive using both mkdir and sudo mkdir.  Maybe 
the btrfs-progs Ubuntu package is not configured correctly... although 
the forum post shows at lest one other person has had this same error. 
I am not sure what distro they were using.

> Thanks,
> Qu
> 
>> I found one forum
>> post that said I needed to make the destination folder manually, then
>> restore. That did not work. looking at your code 2(%d) is a kernel
>> message? not sure what to make of it. I decided to enter a root
>> environment with 'sudo su' and the restore worked(the folder still
>> existed from previous troubleshoot step). The console is showing files
>> being restored. I tried a dry run first which did not show an error.
>> Just some feedback and reference.
>>
>> uname -a
>>
>> Linux emb 4.10.0-38-generic #42-16.04.1-Ubuntu SMP Tue Oct 10 16:21:20
>> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs --version
>>
>> btrfs-progs v4.4
>>
>> Thank you,
>>
>> Jayotis
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
