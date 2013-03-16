Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49474 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3CPMqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 08:46:46 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: cwillu <cwillu@cwillu.com>
Subject: Re: multiple btrfsck runs
Date: Sat, 16 Mar 2013 23:46:40 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201303162302.14746.russell@coker.com.au> <CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
In-Reply-To: <CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303162346.40534.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 16 Mar 2013, cwillu <cwillu@cwillu.com> wrote:
> On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> wrote:
> > Is it expected that running btrfsck more than once will keep reporting
> > errors?
> 
> Without options, btrfsck does not write to the disk.

The man page for the version in Debian doesn't document any options.

The source indicates that --repair might be the one that's desired, is that 
correct?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
