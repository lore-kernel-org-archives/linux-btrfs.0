Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38160 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbJFXvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 19:51:17 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:37690 helo=legolas)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Zjc0m-0006P7-UF
	for <linux-btrfs@vger.kernel.org>; Tue, 06 Oct 2015 16:51:16 -0700
Received: from merlin by legolas with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1Zjc0l-0006I4-Vl
	for linux-btrfs@vger.kernel.org; Tue, 06 Oct 2015 16:51:11 -0700
Date: Tue, 6 Oct 2015 16:51:11 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20151006235111.GO20745@merlins.org>
References: <20151006054034.GA21376@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151006054034.GA21376@merlins.org>
Subject: Re: btrfs kernel hang? (4.1.3)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 10:40:34PM -0700, Marc MERLIN wrote:
> I started doing multiple mencoder/ffmpeg commands, and as I ran one
> more, the system froze up (as in everything froze, even running ssh
> sessions not doing any IO)
> 
> sysrq-W output:
> http://marc.merlins.org/tmp/sysrq_4.1.3.txt
> 
> I'm assuming btrfs is to blame, but I'm not certain.
> Hopefully someone knowledgeable can have a look.

Same exact bug/hang happened again, same condition. Started one ffmpeg
too many, and everything stopped.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
