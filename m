Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33607 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbC2MbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 08:31:11 -0400
Received: by iecvj10 with SMTP id vj10so99161028iec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 05:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d35lub-tec.ln1@hurikhan77.spdns.de>
References: <meq6hm$lbh$1@ger.gmane.org>
	<20150323232212.GL31762@carfax.org.uk>
	<CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
	<mf2701$d5k$1@ger.gmane.org>
	<CAGfcS_k=__EfJssYt9Ra77uAtW6PfqV1fqAX03VfJiPi_T5TBQ@mail.gmail.com>
	<d35lub-tec.ln1@hurikhan77.spdns.de>
Date: Sun, 29 Mar 2015 08:31:10 -0400
Message-ID: <CAGfcS_nG3gt=copDrWS9TEmZ-dn6WD+HODU1SyxNVvbBqLXQ0A@mail.gmail.com>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 29, 2015 at 7:43 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
>
> With the planned performance improvements, I'm guessing the best way will
> become mounting the root subvolume (subvolid 0) and letting duperemove work
> on that as a whole - including crossing all fs boundaries.
>

Why cross filesystem boundaries by default?  If you scan from the root
subvolume you're guanteed to traverse every file on the filesystem
(which is all that can be deduped) without crossing any filesystem
boundaries.  Even if you have btrfs on non-btrfs on btrfs there must
be some other path that reaches the same files when scanning from
subvolid 0.

--
Rich
