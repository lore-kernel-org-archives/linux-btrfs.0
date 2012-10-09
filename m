Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51039 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab2JIO5X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 10:57:23 -0400
Date: Tue, 9 Oct 2012 16:55:59 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Frozen transaction
Message-ID: <20121009145559.GS4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5073D44C.7000601@daevel.fr>
 <20121009095205.GL4405@twin.jikos.cz>
 <5073F758.6080507@daevel.fr>
 <20121009123249.GO4405@twin.jikos.cz>
 <50742B4D.5060600@daevel.fr>
 <20121009140716.GQ4405@twin.jikos.cz>
 <507430E6.8040107@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <507430E6.8040107@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 04:12:54PM +0200, Olivier Bonvalet wrote:
> What I didn't understand, is that since 24 hours, there was near 0 IO
> request done on that device. The cleanup processes was just «frozen», not
> doing anything visible (no CPU and no IO) ; like a deadlock.

Yep, it was a deadlock and I've found Roman's report against 3.6-rc5
that has the same symptoms:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18658.html

The blocked threads are transaction-commit, cleaner and the generic
writeback flusher, it's not the deadlock on s_umount mutex but inside
the tree locks, and still unresolved.

david
