Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54982 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbbDTIPJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:15:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yk6r9-0008VU-Mc
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 10:15:03 +0200
Received: from 78-20-36-53.access.telenet.be ([78.20.36.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 10:15:03 +0200
Received: from gcp by 78-20-36-53.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 10:15:03 +0200
To: linux-btrfs@vger.kernel.org
From: Gian-Carlo Pascutto <gcp@sjeng.org>
Subject: Re: The FAQ on fsync/O_SYNC
Date: Mon, 20 Apr 2015 10:13:47 +0200
Message-ID: <mh2cfv$7rr$1@ger.gmane.org>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com> <49296740.rPqQP4vAjc@merkaba> <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com> <20150420042731.GA20194@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <20150420042731.GA20194@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20-04-15 06:27, Zygo Blaxell wrote:

>> I'm curious as to whether +C has any effect on BTRFS's durability, too.
> 
> I would expect it to be strictly equal to or worse than the CoW
> durability.

In addition to the stuff pointed out, I've wondered about this:
PostgreSQL full_page_writes copies 8k pages in order to prevent
corruption from partial writes. But btrfs has 16k pages by default, so a
corrupted FS page would corrupt more data than PostgreSQL protects.

Maybe it's not an issue if the underlying HW has 512b/4k sectors, or
maybe I'm misunderstanding what the respective features assume, but
unless informed to the contrary I wouldn't be entirely comfortable with
this.

(With CoW enabled, you don't have partial writes, so the point is moot)

-- 
GCP

