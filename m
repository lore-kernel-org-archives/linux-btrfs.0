Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781Ab3GaW4o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 18:56:44 -0400
Date: Wed, 31 Jul 2013 15:56:40 -0700
From: Zach Brown <zab@redhat.com>
To: Mike Audia <mikey_a@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is the checkpoint interval adjustable?
Message-ID: <20130731225640.GO32145@lenny.home.zabbo.net>
References: <20130731221008.156770@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130731221008.156770@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Thank you kindly for the prompt reply.  My goal is to make them _less_
> frequent.

I assumed as much.  I should have added some sympathy smileys :).

>  I am NO programmer by any stretch.  Let's say I want them to be once
> every 5 min (300 sec).  Is the attached patch sane to acheive this?

I think it's a reasonable patch to try, yeah.

>  Are there any unforeseen and effects of doing this?  Thank you for
> the consideration.

I don't *think* that there should be.  One way of looking at it is that
both 30 and 300 seconds are an *eternity* for cpu, memory, and storage.
Any trouble that you could get in to in 300 seconds some other machine
could trivially get in to in 30 with beefier hardware.

But I reserve the right to be wrong.

- z
