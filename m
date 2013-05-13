Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46251 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3EMIeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 04:34:04 -0400
Received: by mail-ob0-f176.google.com with SMTP id wc20so6253747obb.21
        for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 01:34:04 -0700 (PDT)
Received: from mail-oa0-f45.google.com (mail-oa0-f45.google.com [209.85.219.45])
        by mx.google.com with ESMTPSA id eq4sm15350254obb.5.2013.05.13.01.34.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 13 May 2013 01:34:02 -0700 (PDT)
Received: by mail-oa0-f45.google.com with SMTP id j6so6193314oag.18
        for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 01:34:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130508204758.GU12414@localhost.localdomain>
References: <CVrGRAreCXB@helmut.hullen.de> <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org> <20130430135816.GD2580@localhost.localdomain>
 <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
 <20130430175351.GF2580@localhost.localdomain> <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com>
 <20130501185701.GA12414@localhost.localdomain> <CADn-QaNeo2pnu1a94HEWWjaXtdRb2C38JJXrUMy6xBmp+MpCVw@mail.gmail.com>
 <CADn-QaPh9EZjnbr9HoRKTMi8OUgnvfRdD7riEDZ0hpkcNRN93Q@mail.gmail.com> <20130508204758.GU12414@localhost.localdomain>
From: Alexander Skwar <a@skwar.me>
Date: Mon, 13 May 2013 10:33:42 +0200
Message-ID: <CADn-QaOtusn2jUuXJDT-X0c3+hhx1_6Y969wqOnd_epHVW74eA@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
 [btrfs]()
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef

On Wed, May 8, 2013 at 10:47 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, May 08, 2013 at 11:34:40AM -0600, Alexander Skwar wrote:
>> Hello Josef
>>
>> Did you have a chance to look at that image? Did you find anything?
>>
>> Or should I simply create a new filesystem and forget about the issue?
>>
>
> So the file system isn't corrupt, you just got a giant block group for some
> reason.

Hmm...

Sure?

I did start a "btrfs balance" and it consistently fails. See my dmesg
output at http://pastebin.com/7XgAhZ1s

At first, there are a few WARNING messages:

[  300.422702] WARNING: at
/build/buildd/linux-3.8.0/fs/btrfs/delayed-ref.c:454
update_existing_ref+0x119/0x150 [btrfs]()

[  300.422960] WARNING: at
/build/buildd/linux-3.8.0/fs/btrfs/delayed-ref.c:454
update_existing_ref+0x119/0x150 [btrfs]()
…

But there's also an error:

[  300.425633] BTRFS error (device dm-5) in
__btrfs_inc_extent_ref:1935: Object already exists
[  300.425634] btrfs is forced readonly


What can I do? Other than destroying that filesystem?

Regards,

Alexander
-- 
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
