Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57825 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761191Ab3BNAD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 19:03:27 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 506F63EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 09:03:25 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3980245DE50
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 09:03:25 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 230DA45DE4E
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 09:03:25 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 14C161DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 09:03:25 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C0DAA1DB8037
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 09:03:24 +0900 (JST)
Message-ID: <511C29B7.9060805@jp.fujitsu.com>
Date: Thu, 14 Feb 2013 09:03:03 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        chris.mason@fusionio.com, dsterba@suse.cz, kreijack@gmail.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com> <5119C379.7080305@redhat.com> <5119D813.40101@jp.fujitsu.com> <511A8228.9060109@redhat.com> <20130212205731.GA11872@lenny.home.zabbo.net> <511B18BD.7070706@jp.fujitsu.com> <20130213215833.GC22221@lenny.home.zabbo.net>
In-Reply-To: <20130213215833.GC22221@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/14 6:58, Zach Brown wrote:
>>> why it failed.  But it might not be able to because /proc/swaps is
>>> fundamentally unreliable.
>>
>> Then, how should we do?    I have no idea...
>
> Hmm.  I think I'd do something like:
>
> - First always open with O_EXCL.  If it succeeds then there's no reason
>    to check /proc/swaps at all.  (Maybe it doesn't need to try
>    check_mounted() there either?  Not sure if it's protecting against
>    accidentally mounting mounted shared storage or not.)

check_mounted() is necessary for multiple devices, I think.

>
> - Try stat()ing the /proc/swaps paths and the command line path.  If they
>    point to the same inode then print a helpful message that the open
>    might have failed because the file is an active swap file.
>
> - Use realpath() to resolve the relative path into an absolute path.
>    Copy it and escape control chars ("\n\t\\") with their \0xxx octal
>    equivalents.  If the mangled absolute path matches the path in
>    /proc/swaps (without opening), print the helpful message.

I think realpath() is unnecessary if it checks it by using only
stat() information. (if do not compare path)

Am I misunderstanding anything?

Thanks,
Tsutomu

>
> - At no point is failure of any of the /proc/swaps parsing fatal.  It'd
>    carry on ignoring errors until it doesnt have work to do.  It'd only
>    ever print the nice message when it finds a match.
>
> That seems reasonable to me.  It costs nothing in the vast majority of
> invocations when nothing goes wrong, it doesn't *cause* problems, and
> it'd print helpful messages on boring normal systems when someone really
> does accidentally try and mkfs a swapfile.
>
> In very rare cases /proc/swaps won't be of any help.  The user would
> only see the open failure.  That's fine, it's just not worth worrying
> about.
>
> - z



