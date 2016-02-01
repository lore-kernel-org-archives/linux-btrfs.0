Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34693 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbcBAUjA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 15:39:00 -0500
Received: by mail-io0-f175.google.com with SMTP id 9so92619347iom.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 12:38:59 -0800 (PST)
Subject: Re: Question about a specific error.
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56AFB598.2020307@gmail.com> <20160201202112.GB8313@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AFC213.8040501@gmail.com>
Date: Mon, 1 Feb 2016 15:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <20160201202112.GB8313@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-01 15:21, Hugo Mills wrote:
> On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
>> In the process of trying to debug issues I'm having on one of my
>> systems with a new kernel version, I decided to do a dry run check on
>> the root filesystem.  'btrfs check' returned a bunch of lines like:
>>
>> root 257 inode XXXXXX errors 2000, link count wrong
>>          unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index
>>
>> I got about 20 messages like this with varying values for everything
>> except the filetype and error counts.  Based on what I can tell, these
>> look like orphaned inodex, but I'm not certain.
>> Is it safe to tell BTRFS to try and fix these errors?
>
>     Yes, those are errors I'd expect btrfs check --repair to handle
> properly.
>
Out of curiosity, do you happen to know if this is how btrfs check 
reports orphaned inodes, or is this something else entirely?

