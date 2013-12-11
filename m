Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52353 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3LKDTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 22:19:32 -0500
Received: by mail-vc0-f174.google.com with SMTP id id10so5207002vcb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 19:19:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
Date: Wed, 11 Dec 2013 05:19:30 +0200
Message-ID: <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'm not a developer, I'm just an ape who wears pants. Chris Mason is the
> lead developer. All I can say about it is that it's been working for me OK
> so far.

Great:) Now, I understand that you were using "-d dup", which is quite
valuable for me. And since GMail only show first names in Inbox list,
I thougth you were Chris Mason. Sorry. Now, I see your full name
in the header.


>> Can '-M' requirement be an indication of code which has not been
>> ironed out, or is it simply a constraint of the internal machinery?

> I think it's just how chunks are allocated it becomes space inefficient to
> have two separate metadata and data chunks, hence the requirement to mix
> them if -d dup is used. But I'm not really sure.


Sounds like it is implemented paralel/similar to "-m dup". That's why "-M"
is implied. Of course we are speculating here..

Now the question is, is it a good practice to use "-M" for large filesystems?
Pros, Cons? What is the performance impact? Or any other possible impact?


> Well given that Btrfs is still flagged as experimental, most notably when
> creating any Btrfs file system, I'd say that doesn't apply here. If the case
> you're trying to mitigate is some kind of corruption that can only be
> repaired if you have at least one other copy of data, then -d dup is useful.
> But obviously this ignores the statistically greater chance of a more
> significant hardware failure, as this is still single device.


>From the beginning we've put possiblity of full hardware failure aside.
The user is expected to handle that risk elsewhere.

Our scope is about localized failures which may cost you
some files. Since btrfs has checksums you may be aware of them.
Using "-d dup" we increase our chances of recovering from them.

But probablity of corruption of all duplicates is non zero.
Hence checking the output of "btrfs scrub start <path>" is beneficial
before making/updating any backups. And then check the output of the
scrub on the backup too..


> Not only could
> the entire single device fail, but it's possible that erase blocks
> individually fail. And since the FTL decides where pages are stored, the
> duplicate data/metadata copies could be stored in the same erase block. So
> there is a failure vector other than full failure where some data can still
> be lost on a single device even with duplicate, or triplicate copies.


I guess you are talking about SSD's. Even if you write duplicates
on distinct erase blocks, they may end up in same block after
firmware's relocation, defragmentation, migration, remapping,
god knows what ...ation operations. So practically, block
address does not point any fixed physical location on SSDs.

What's more (in relation to our long term data integrity aim)
order of magnitude for their unpowered data retension period is
1 YEAR. (Read it as 6months to 2-3 years. While powered they
refresh/shuffle the blocks) This makes SSDs
unsuitable for mid-to-long tem consumer storage. Hence they are
out of this discussion. (By the way, the only way for reliable
duplication on SSDs, is using physically seperate devices.)

Luckly we have hard drives with still sensible block addressing.
Even with bad block relocation. So duplication, triplicate,.... still
makes sense.. Or IS IT? Comments?

i.e. The new Advanced format drives may employ 4K blocks
but present 512B logical blocks which may be another reencarnation
of the SSD problem above. However, I guess linux kernel does not
access such drives using logical addressing..

Imran
