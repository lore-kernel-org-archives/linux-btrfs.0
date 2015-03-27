Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33800 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbC0AaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 20:30:12 -0400
Received: by iedfl3 with SMTP id fl3so67272487ied.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 17:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mf2701$d5k$1@ger.gmane.org>
References: <meq6hm$lbh$1@ger.gmane.org>
	<20150323232212.GL31762@carfax.org.uk>
	<CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
	<mf2701$d5k$1@ger.gmane.org>
Date: Thu, 26 Mar 2015 20:30:11 -0400
Message-ID: <CAGfcS_k=__EfJssYt9Ra77uAtW6PfqV1fqAX03VfJiPi_T5TBQ@mail.gmail.com>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Martin <m_btrfs@ml1.co.uk>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 8:07 PM, Martin <m_btrfs@ml1.co.uk> wrote:
>
> Anyone with any comments on how well duperemove performs for TB-sized
> volumes?

Took many hours but less than a day for a few TB - I'm not sure
whether it is smart enough to take less time on subsequent scans like
bedup.

>
> Does it work across subvolumes? (Presumably not...)

As far as I can tell, yes.  Unless you pass a command-line option it
crosses filesystem boundaries and even scans non-btrfs filesystems
(like /proc, /dev, etc).  Obviously you'll want to avoid that since it
only wastes time and I can just imagine it trying to hash kcore and
such.

Other than being less-than-ideal intelligence-wise, it seemed
effective.  I can live with that in an early release like this.

--
Rich
