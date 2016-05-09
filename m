Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.zener.es ([62.14.230.213]:35060 "EHLO zener.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbcEIK4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 06:56:38 -0400
From: Alejandro Vargas <anv@zener.es>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: empty disk reports full
Date: Mon, 09 May 2016 12:56:32 +0200
Message-ID: <1757853.p9qfQBkHmV@anv.localdomain>
In-Reply-To: <CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
References: <2879842.8EgedBzSUf@anv.localdomain> <2288281.DWWvr4SJAK@anv.localdomain> <CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Martes, 26 de abril de 2016 00:08:49 Chris Murphy escribió:
> On Mon, Apr 25, 2016 at 8:03 AM, Alejandro Vargas <anv@zener.es> wrote:

> I suggest unmounting and running 'btrfs check' (without repair) and
> see if that gives any new information.

I tried btrfs check but... see the result:

# btrfs check /dev/sdb1 
Checking filesystem on /dev/sdb1
UUID: cbfe8735-9f53-46f5-be7e-40f6a61a5506
checking extents
Killed


I tried it several times with the same result.
