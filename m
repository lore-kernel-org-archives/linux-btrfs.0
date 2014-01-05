Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57555 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaAEQzO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 11:55:14 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C87B67.1040503@friedels.name>
Date: Sun, 5 Jan 2014 09:55:10 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 4, 2014, at 2:21 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hi Chris,
> 
> 
> >> I ran btrfsck on my volume with the repair option. When I re-run it, >>I get the same errors as before.
>> 
>> Did you try mounting with -o recovery first?
>> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
> 
> No, I did not.
> In fact, I had visited the FAQ before, and my understanding was, that -o recovery was used/needed when mounting is impossible. This is not the case. In fact, the disk does work without obvious problems.

It mounts without errors? So why then btrfsck/btrfs repair? What precipitated the repair?

If mount option -o recovery is used, dmesg should report 'btrfs: enabling auto recovery' and I think you're right if it's mounting OK then probably recovery isn't applicable. Can you just do a btrfs check <dev> and report the results? Repair can sometimes make problems worse it seems.


Chris Murphy

