Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36302 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbJOESg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 00:18:36 -0400
Received: by wicgb1 with SMTP id gb1so255101068wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 21:18:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
Date: Thu, 15 Oct 2015 15:18:35 +1100
Message-ID: <CA+WRLO-0SMMuU61Mu94Kd5X2E9swT_eUgHf9eQNq9itz4D1xNg@mail.gmail.com>
Subject: Re: BTRFS raid 5/6 status
From: Gareth Pye <gareth@cerberos.id.au>
To: audio muze <audiomuze@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 15, 2015 at 3:11 PM, audio muze <audiomuze@gmail.com> wrote:
> Rebuilds and/or expanding the array should be pretty quick given only
> actual data blocks are written on rebuild or expansion as opposed to
> traditional raid systems that write out the entire array.


While that might be the intended final functionality I don't think
balances are anywhere near that optimised currently.

Starting with a relatively green format isn't a great option for a
file system you intend to use for ever.

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
