Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59684 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbDSP2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 11:28:30 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Craig Ringer <craig@2ndquadrant.com>
Subject: Re: The FAQ on fsync/O_SYNC
Date: Mon, 20 Apr 2015 01:28:25 +1000
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com> <49296740.rPqQP4vAjc@merkaba> <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
In-Reply-To: <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504200128.25934.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Apr 2015, Craig Ringer <craig@2ndquadrant.com> wrote:
> PostgreSQL is its self copy-on-write (because of multi-version
> concurrency control), so it doesn't make much sense to have the FS
> doing another layer of COW.

That's a matter of opinion.

I think it's great if PostgreSQL can do internal checkums and error 
correction.  But I'd rather not have to test that functionality in the field.

Really I prefer to have the ZFS copies= option for databases.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
