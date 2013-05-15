Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58764 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759756Ab3EOR2i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 13:28:38 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: subvol copying
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAFWF=ak7tJnaCdUst7gBLpCPj8s2z0iOnXMDR63AVjiYX8X6dQ@mail.gmail.com>
Date: Wed, 15 May 2013 11:28:33 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <9E8AFAF6-ACA6-44BB-A4CF-89B6E50E8BCB@colorremedies.com>
References: <201305151525.27913.russell@coker.com.au> <kmve61$cqe$1@ger.gmane.org> <4BF95473-B35B-4B3B-9437-24448B279AB1@colorremedies.com> <CAFWF=ak7tJnaCdUst7gBLpCPj8s2z0iOnXMDR63AVjiYX8X6dQ@mail.gmail.com>
To: Harald Glatt <mail@hachre.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 15, 2013, at 10:44 AM, Harald Glatt <mail@hachre.de> wrote:

> 
> You make a ro snapshot rw by creating a snapshot of it that is rw. So
> yes to both questions, by doing the same thing in both cases.

In other words, a normal snapshot (without -r) of a read-only snapshot will create a rw snapshot?

In any case, for the OP, making a rw snapshot of the last backup ro snapshot, and putting it in place of the home folder is the way to do the rollback.


Chris Murphy