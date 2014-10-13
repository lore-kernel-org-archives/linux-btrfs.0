Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:49701 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaJMU5g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 16:57:36 -0400
Received: by mail-vc0-f180.google.com with SMTP id le20so6295758vcb.25
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 13:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
Date: Mon, 13 Oct 2014 16:57:35 -0400
Message-ID: <CAGfcS_npiPrdRxAk7Kmt5zpE0st8PW7DoWkzk9ekB75G+ixyMw@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: john terragon <jterragon@gmail.com>
Cc: David Arendt <admin@prnet.org>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 4:55 PM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Mon, Oct 13, 2014 at 4:48 PM, john terragon <jterragon@gmail.com> wrote:
>>
>> After the rebooting (or the remount) I consistently have the corruption
>> with the usual multitude of these in dmesg
>> "parent transid verify failed on 902316032 wanted 2484 found 4101"
>> and the characteristic ls -la output

Sorry to double-reply, but I left this out.  I have a long string of
these early in boot as well that I never noticed before.

--
Rich
