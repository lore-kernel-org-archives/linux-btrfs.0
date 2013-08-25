Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:48966 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab3HYWK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 18:10:26 -0400
Received: from shiva (unknown [88.171.134.228])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 711224B00C1
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 00:10:16 +0200 (CEST)
Message-ID: <521A80C5.70208@pook.it>
Date: Mon, 26 Aug 2013 00:10:13 +0200
From: Stuart Pook <slp644161@pook.it>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: uncorrectable errors after btrfs replace
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com> <434c716a-7687-4738-bb24-f4752ada1e3f@email.android.com> <52138852.3080605@giantdisaster.de>
In-Reply-To: <52138852.3080605@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/08/13 17:16, Stefan Behrens wrote:

> I spent my whole day yesterday to check the replace procedure for errors
> by doing similar things like you did, including inserting write errors,
> using LUKS and everything.

thanks

> The only issue that I was able to find was
> that it is not checked whether the filesystem is in read-only mode when
> the operation starts.

Note that I started the replace and then set the filesystem to readonly.  The replace then stopped.  I set the filesystem back to readwrite and restarted the replace.

> Therefore I'm looking forward to read
> through your kernel log files.

I emailed them to Stefan Behrens & Chris Murphy.  Please let me know if you did not get them (presumably because they are too big).

Stuart
