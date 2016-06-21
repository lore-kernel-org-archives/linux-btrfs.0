Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.181.169]:34098 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbcFUXbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 19:31:11 -0400
Received: from smtp21.mail.ru (smtp21.mail.ru [94.100.179.250])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 1991E1E4028B
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 02:31:06 +0300 (MSK)
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:44058 helo=centurion.home)
	by smtp21.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bFV8A-00024h-JM
	for linux-btrfs@vger.kernel.org; Wed, 22 Jun 2016 02:30:55 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion.home (Postfix) with ESMTPSA id E4F121DCF99
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 01:30:51 +0200 (CEST)
Subject: Re: Is "btrfs balance start" truly asynchronous?
To: linux-btrfs@vger.kernel.org
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
 <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
 <20160621113339.GA3325@carfax.org.uk>
 <176a9733-ade2-d3a6-a9aa-1476d6afb3e1@gmail.com>
 <57693E72.1090706@cobb.uk.net>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <5769CE2E.2000306@mail.ru>
Date: Wed, 22 Jun 2016 01:30:54 +0200
MIME-Version: 1.0
In-Reply-To: <57693E72.1090706@cobb.uk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-21 15:17, Graham Cobb wrote:
> On 21/06/16 12:51, Austin S. Hemmelgarn wrote:
>> The scrub design works, but the whole state file thing has some rather
>> irritating side effects and other implications, and developed out of
>> requirements that aren't present for balance (it might be nice to check
>> how many chunks actually got balanced after the fact, but it's not
>> absolutely necessary).
> 
> Actually, that would be **really** useful.  I have been experimenting
> with cancelling balances after a certain time (as part of my
> "balance-slowly" script).  I have got it working, just using bash
> scripting, but it means my script does not know whether any work has
> actually been done by the balance run which was cancelled (if no work
> was done, but it timed out anyway, there is probably no point trying
> again with the same timeout later!).

Additionally it would be nice if balance/scrub reports the status via
/proc in human readable manner (similar to /proc/mdstat).

-- 
With best regards,
Dmitry
