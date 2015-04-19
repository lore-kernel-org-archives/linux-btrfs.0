Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36442 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbDSObD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 10:31:03 -0400
Received: by oift201 with SMTP id t201so108219263oif.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 07:31:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49296740.rPqQP4vAjc@merkaba>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
	<49296740.rPqQP4vAjc@merkaba>
Date: Sun, 19 Apr 2015 22:31:02 +0800
Message-ID: <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
Subject: Re: The FAQ on fsync/O_SYNC
From: Craig Ringer <craig@2ndquadrant.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 April 2015 at 22:28, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Am Sonntag, 19. April 2015, 21:20:11 schrieb Craig Ringer:
>> Hi all
>
> Hi Craig,
>
>> I'm looking into the advisability of running PostgreSQL on BTRFS, and
>> after looking at the FAQ there's something I'm hoping you could
>> clarify.
>>
>> The wiki FAQ says:
>>
>> "Btrfs does not force all dirty data to disk on every fsync or O_SYNC
>> operation, fsync is designed to be fast."
>>
>> Is that wording intended narrowly, to contrast with ext3's nasty habit
>> of flushing *all* dirty blocks for the entire file system whenever
>> anyone calls fsync() ? Or is it intended broadly, to say that btrfs's
>> fsync won't necessarily flush all data blocks (just metadata) ?
>>
>> Is that statement still true in recent BTRFS versions (3.18, etc)?
>
> I don´t know, thus leave that for others to answer. I always assumed a
> strong fsync() guarentee as in "its on disk" with BTRFS. So I am
> interested in that as well.
>
> But for databases, did you consider the copy on write fragmentation BTRFS
> will give? Even with autodefrag, afaik it is not recommended to use it for
> large databases on rotating media at least.

I did, and any testing would need to look at the efficacy of the
chattr +C option on the database directory tree.

PostgreSQL is its self copy-on-write (because of multi-version
concurrency control), so it doesn't make much sense to have the FS
doing another layer of COW.

I'm curious as to whether +C has any effect on BTRFS's durability, too.

-- 
 Craig Ringer                   http://www.2ndQuadrant.com/
 PostgreSQL Development, 24x7 Support, Training & Services
