Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34872 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbcGFQLb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 12:11:31 -0400
Received: by mail-io0-f195.google.com with SMTP id k78so1296767ioi.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 09:11:30 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, antonio@gnu.org
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
 <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
 <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de>
 <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com>
Cc: linux-btrfs@vger.kernel.org, bug-tar@gnu.org, adilger@dilger.ca
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2ed25df0-4204-a7bc-66c7-85d2ccdb77fb@gmail.com>
Date: Wed, 6 Jul 2016 12:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 12:05, Austin S. Hemmelgarn wrote:
> On 2016-07-06 11:22, Joerg Schilling wrote:
>> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>>
>>>> It should be obvious that a file that offers content also has
>>>> allocated blocks.
>>> What you mean then is that POSIX _implies_ that this is the case, but
>>> does not say whether or not it is required.  There are all kinds of
>>> counterexamples to this too, procfs is a POSIX compliant filesystem
>>> (every POSIX certified system has it), yet does not display the behavior
>>> that you expect, every single file in /proc for example reports 0 for
>>> both st_blocks and st_size, and yet all of them very obviously have
>>> content.
>>
>> You are mistaken.
>>
>> stat /proc/$$/as
>>   File: `/proc/6518/as'
>>   Size: 2793472         Blocks: 5456       IO Block: 512    regular file
>> Device: 5440000h/88342528d      Inode: 7557        Links: 1
>> Access: (0600/-rw-------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
>> Access: 2016-07-06 16:33:15.660224934 +0200
>> Modify: 2016-07-06 16:33:15.660224934 +0200
>> Change: 2016-07-06 16:33:15.660224934 +0200
>>
>> stat /proc/$$/auxv
>>   File: `/proc/6518/auxv'
>>   Size: 168             Blocks: 1          IO Block: 512    regular file
>> Device: 5440000h/88342528d      Inode: 7568        Links: 1
>> Access: (0400/-r--------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
>> Access: 2016-07-06 16:33:15.660224934 +0200
>> Modify: 2016-07-06 16:33:15.660224934 +0200
>> Change: 2016-07-06 16:33:15.660224934 +0200
>>
>> Any correct implementation of /proc returns the expected numbers in
>> st_size as
>> well as in st_blocks.
> Odd, because I get 0 for both values on all the files in /proc/self and
> all the top level files on all kernels I tested prior to sending that
> e-mail, for reference, they include:
> * A direct clone of HEAD on torvalds/linux
> * 4.6.3 mainline
> * 4.1.27 mainline
> * 4.6.3 mainline with a small number of local patches on top
> * 4.1.19+ from the Raspberry Pi foundation
> * 4.4.6-gentoo (mainline with Gentoo patches on top)
> * 4.5.5-linode69 (not certain about the patches on top)
Further ones I've now tested that behave like the others listed above:
* 2.4.20-8 from RedHat 9
* 2.6.18-1.2798.fc6 from Fedora Core 6
* 3.11.10-301.fc20 from Fedora 20

IOW, it looks like whatever you're running is an exception here.
