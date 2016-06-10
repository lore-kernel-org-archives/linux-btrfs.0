Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58673 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbcFJQzL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 12:55:11 -0400
From: Nikolaus Rath <Nikolaus@rath.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<87fuslg19q.fsf@vostro.rath.org>
	<ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
	<87twh1t4xv.fsf@thinkpad.rath.org> <20160610165046.GA18657@angband.pl>
Date: Fri, 10 Jun 2016 09:55:06 -0700
In-Reply-To: <20160610165046.GA18657@angband.pl> (Adam Borowski's message of
	"Fri, 10 Jun 2016 18:50:46 +0200")
Message-ID: <878tydt251.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jun 10 2016, Adam Borowski <kilobyte@angband.pl> wrote:
> On Fri, Jun 10, 2016 at 08:54:36AM -0700, Nikolaus Rath wrote:
>> On Jun 10 2016, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>> > JFYI, if you've using GNU cp, you can pass '--reflink=never' to avoid
>> > it making reflinks.
>> 
>> I would have expected so, but at least in coreutils 8.23 the only valid
>> options are "never" and "auto" (at least according to cp --help and the
>> manpage).
>
> Where do you get "never" from?

I meant to write "always" (as in my second mail, I thought I hit "cancel"
quickly enough).


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
