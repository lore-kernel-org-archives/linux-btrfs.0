Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33.italiaonline.it ([212.48.25.161]:53478 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756334AbbE2RC7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 13:02:59 -0400
Message-ID: <55689BC3.40306@inwind.it>
Date: Fri, 29 May 2015 19:02:59 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, Stef Bon <stefbon@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Plans for a library for btrfs?
References: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com> <20150529193123.1ecb5d8a@natsu>
In-Reply-To: <20150529193123.1ecb5d8a@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-05-29 16:31, Roman Mamedov wrote:
> On Wed, 27 May 2015 14:31:28 +0200
> Stef Bon <stefbon@gmail.com> wrote:
> 
>> This program, which I've called fuse-backup, creates backup subvolumes
>> and snapshots by calling an extrenal script, which does something
>> like:
>>
>> btrfs subvolume snapshot -r %PathToBackup%/ %PathToSnapshot%
>>
>> This works perfect, but are there any plans to do this with a library?
> 
> If this works perfect, then what is the rationale for needing a library?

The problem in calling another executable, is that is very difficult to parse the program output.
For "btrfs sub snap" it is easy; but what about "btrfs fi df" or "btrfs fi show" ?

> Do you see a clear reason aside from any vague "it's supposed to be that way".
> In the Unix land it is perfectly normal for programs to call other
> self-contained programs to do their self-contained jobs:

Right, but now btrfs is a collection of tools; I don't think that it could e considered a "self-contained programs"... Other programs (eg systemd, udev) rewrite some code in order to avoid to call an external executable. This leads to code duplication with all the associated problems...

> http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2877684
> Not everything must to be a library linked into your main executable, some
> separation and calling external programs to do stuff such as mkfs or snapshot
> management seems perfectly fine and even better from the debug-ability
> standpoint.





-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
