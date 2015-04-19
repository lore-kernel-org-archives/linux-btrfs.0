Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35104 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbDSO2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 10:28:09 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Craig Ringer <craig@2ndquadrant.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Date: Sun, 19 Apr 2015 16:28:07 +0200
Message-ID: <49296740.rPqQP4vAjc@merkaba>
In-Reply-To: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 19. April 2015, 21:20:11 schrieb Craig Ringer:
> Hi all

Hi Craig,

> I'm looking into the advisability of running PostgreSQL on BTRFS, and
> after looking at the FAQ there's something I'm hoping you could
> clarify.
> 
> The wiki FAQ says:
> 
> "Btrfs does not force all dirty data to disk on every fsync or O_SYNC
> operation, fsync is designed to be fast."
> 
> Is that wording intended narrowly, to contrast with ext3's nasty habit
> of flushing *all* dirty blocks for the entire file system whenever
> anyone calls fsync() ? Or is it intended broadly, to say that btrfs's
> fsync won't necessarily flush all data blocks (just metadata) ?
> 
> Is that statement still true in recent BTRFS versions (3.18, etc)?

I don´t know, thus leave that for others to answer. I always assumed a 
strong fsync() guarentee as in "its on disk" with BTRFS. So I am 
interested in that as well.

But for databases, did you consider the copy on write fragmentation BTRFS 
will give? Even with autodefrag, afaik it is not recommended to use it for 
large databases on rotating media at least.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
