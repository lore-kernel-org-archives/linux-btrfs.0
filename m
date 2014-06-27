Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51477 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0POw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 11:14:52 -0400
Received: by mail-vc0-f171.google.com with SMTP id id10so5218098vcb.16
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 08:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$81d96$8a4effae$94572f09$472a11ff@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<pan$81d96$8a4effae$94572f09$472a11ff@cox.net>
Date: Fri, 27 Jun 2014 11:14:51 -0400
Message-ID: <CAGfcS_khFRS3nMOtAD7srzHg6Q73LF1iogEzTy4YH1KW=qEu0g@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 9:06 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Hopefully that problem's fixed on 3.16-rc2+, but as of yet there's not
> enough 3.16-rc2+ reports out there from folks experiencing issues with
> 3.15 blocked tasks to rightfully say.

Any chance that it was backported to 3.15.2?  I'd rather not move to
mainline just for btrfs.

I got another block this morning and failed to capture a log before my
terminals gave out.  I switched back to 3.15.0 for the moment, and
we'll see if that fares any better.

Rich
