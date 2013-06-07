Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59467 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3FGUSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 16:18:00 -0400
Date: Fri, 7 Jun 2013 14:48:44 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
Message-ID: <20130607184844.GE25323@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <1370280485-10047-2-git-send-email-joern@logfs.org>
 <CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
 <20130606181248.GA17707@logfs.org>
 <CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
 <20130607163658.GC25323@logfs.org>
 <CAHp75VdBb3Gt+sYwDbJo8BXRSsxwN0K6qw_UeJve6ycQwz2WBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHp75VdBb3Gt+sYwDbJo8BXRSsxwN0K6qw_UeJve6ycQwz2WBQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 June 2013 21:30:16 +0300, Andy Shevchenko wrote:
> >
> > spin_lock
> > list_for_each_entry_safe
> >         list_del
> >         spin_unlock
> 
> Who is doing such thing?

Replace list_for_each_entry_safe with 'while (!list_empty(...))' and
just grep.  My patch is about 'while (!list_empty(...))', not about
list_for_each_entry_safe.

Jörn

--
There are three principal ways to lose money: wine, women, and engineers.
While the first two are more pleasant, the third is by far the more certain.
-- Baron Rothschild
