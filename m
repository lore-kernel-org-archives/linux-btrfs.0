Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:50698 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaDHMFc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 08:05:32 -0400
Received: by mail-ig0-f177.google.com with SMTP id ur14so925017igb.16
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 05:05:31 -0700 (PDT)
Message-ID: <5343E615.9060809@gmail.com>
Date: Tue, 08 Apr 2014 08:05:41 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
References: <2692878.dRG1K49eOP@fnix>	<7675297.F25Z3Ox7Yz@tethys>	<pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>	<12471892.pAn1KAtSS4@tethys>	<5342C00F.8070001@gmail.com> <CAFvQSYQeUiYTpL32rJnxynP-u=wsNbF-Ufsfw-Wmi9XisuJSHw@mail.gmail.com>
In-Reply-To: <CAFvQSYQeUiYTpL32rJnxynP-u=wsNbF-Ufsfw-Wmi9XisuJSHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-08 07:56, Clemens Eisserer wrote:
> Hi,
> 
>> This is because every other filesystem (except ZFS) doesn't use COW
>> semantics.
> 
> Nilfs2 also is COW based.
> 
> Regards, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Apologies, I had forgotten about NILFS2 (probably because I choose not
to deal with it due to stability issues that i have experienced, and a
lack of XATTR and ACL support).
