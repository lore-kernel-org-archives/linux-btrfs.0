Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:39927 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbcAJWcY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 17:32:24 -0500
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "cheater00 ." <cheater00@gmail.com>, Russell Coker <russell@coker.com.au>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <201601101716.43204.russell@coker.com.au>
 <CA+9GZUhSQe4Yk-dm+=D_6xTAMh7y6B-29wwEiaTNpw84rETcsg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5692DBF6.6010706@bouton.name>
Date: Sun, 10 Jan 2016 23:32:22 +0100
MIME-Version: 1.0
In-Reply-To: <CA+9GZUhSQe4Yk-dm+=D_6xTAMh7y6B-29wwEiaTNpw84rETcsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 10/01/2016 23:24, cheater00 . a écrit :
>> Please test this with the common mail server software, EG Postfix, Exim,
>> Procmail, Maildrop, Dovecot, etc.  The BTRFS bug as described won't cause data
>> loss with any of them.
> [...]
> because the sender only retries for 60 seconds and then throws away
> the message forever. There you go, loss of data and service.

What Russel was trying to say is that it's not how SMTP (and in general
any system/protocol where data is important) works. If the sender
behaves like this he is the one with a defective system.

Lionel
