From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: slow deletion of files
Date: Mon, 12 Jul 2010 22:30:20 +0200
Message-ID: <AANLkTim2GsB-1BKaDUDbvzWkvNRi3YKe7c2iiGm6nRS9@mail.gmail.com>
References: <i1cm80$901$1@dough.gmane.org>
	<4C3A27A0.6090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C3A27A0.6090907@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>> during my testing of btrfs I found out,
>> that deletion of directory with many files (many millions) takes veeeery
>> long (it is running two weeks now and did not finish).

Same for me. I moved back to ext4 on my backup-drive because deleting
old backups created with BackInTime took forever to delete.

Another reason I moved away was btrfs corrupted, and btrfsck is still
not able to repair it.
I really like btrfs but in my opinion it has still a long road to go
and declaring it stable in 2.6.35 is quite optimistic at best.

- Clemens
