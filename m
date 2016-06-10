Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52401 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbcFJPzO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 11:55:14 -0400
From: Nikolaus Rath <Nikolaus@rath.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<87fuslg19q.fsf@vostro.rath.org>
	<ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
Date: Fri, 10 Jun 2016 08:55:11 -0700
Message-ID: <87shwlt4ww.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jun 10 2016, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> JFYI, if you've using GNU cp, you can pass '--reflink=never' to avoid
> it making reflinks.

I would have expected so, but at least in coreutils 8.23 the only valid
options are "always" and "auto" (at least according to cp --help and the
manpage).

Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
