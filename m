Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36364 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2HNOog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 10:44:36 -0400
Received: by yhmm54 with SMTP id m54so501888yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 07:44:36 -0700 (PDT)
Message-ID: <1344955473.2652.1.camel@ayu>
Subject: Re: raw partition or LV for btrfs?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: cwillu <cwillu@cwillu.com>
Cc: "Fajar A. Nugraha" <list@fajar.net>, Daniel Pocock <daniel@pocock.com.au>,
        linux-btrfs@vger.kernel.org
Date: Tue, 14 Aug 2012 10:44:33 -0400
In-Reply-To: <CAE5mzvj_xX6dZVSd3joi9Pgn-yxiRA3Aa+Aqam3gj-VCbQ6C=Q@mail.gmail.com>
References: <5027DDFC.60504@pocock.com.au>
	 <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
	 <502A529B.8060201@pocock.com.au>
	 <CAG1y0sdEePQbRUwvmbCqGMxfPqwCiUKxWcuxczFFEhtait1sNQ@mail.gmail.com>
	 <CAE5mzvj_xX6dZVSd3joi9Pgn-yxiRA3Aa+Aqam3gj-VCbQ6C=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-08-14 at 08:09 -0600, cwillu wrote:
> >> If I understand correctly, if I don't use LVM, then such move and resize
> >> operations can't be done for an online filesystem and it has more risk.
> >
> > You can resize, add, and remove devices from btrfs online without the
> > need for LVM. IIRC LVM has finer granularity though, you can do
> > something like "move only the first 10GB now, I'll move the rest
> > later".
> 
> You can certainly resize the filesystem itself, but without lvm I
> don't believe you can resize the underlying partition online.

There are actually some patches floating around that will allow
partitions (MBR/GPT) to be resized online, I think they're queued up to
be included in some upcoming linux release:
http://lwn.net/Articles/481141/

You still can't move partitions online, of course.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

