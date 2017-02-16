Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:55288 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbdBPOHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 09:07:04 -0500
Date: Thu, 16 Feb 2017 15:07:01 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.9/4.10 Experiences
Message-ID: <20170216140701.ec66y43qajbjcmkm@angband.pl>
References: <CAK5rZE42HLb6kxGWmLqhwBb8arjZDc8yr6H6FLKkWu5XMQMW6Q@mail.gmail.com>
 <CAK5rZE4=34O2d+Tz8=r=_u2tMsipB3OKh3c3YWukX-YzL1JCaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAK5rZE4=34O2d+Tz8=r=_u2tMsipB3OKh3c3YWukX-YzL1JCaA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2017 at 01:37:53PM +0200, Imran Geriskovan wrote:
> What are your experiences for btrfs regarding 4.10 and 4.11 kernels?
> I'm still on 4.8.x. I'd be happy to hear from anyone using 4.1x for
> a very typical single disk setup. Are they reasonably stable/good
> enough for this case?

Somehow, not one disk has spontaneously burst into flame on 4.9 nor 4.10-rc
for me yet, so I guess so.

Also, 4.9 is a LTS that's going to be maintained for 5½ years so it is
supposed to be stable.  And there's no evidence it is not.  Experimental
features continue to be in a bad shape, but you don't appear to be going to
use them.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
