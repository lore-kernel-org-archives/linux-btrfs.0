Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36863 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbI1VLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 17:11:35 -0400
Received: by pablk4 with SMTP id lk4so87417880pab.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 14:11:34 -0700 (PDT)
Date: Mon, 28 Sep 2015 14:11:33 -0700
From: Omar Sandoval <osandov@osandov.com>
To: =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20150928211133.GA23532@mew>
References: <1443463025.16163.6.camel@system.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1443463025.16163.6.camel@system.is>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 05:57:05PM +0000, Gabríel Arthúr Pétursson wrote:
> Hello everyone!
> 
> The attached patches to linux and btrfs-progs add support for filtering
> based on the number of strips in a block when balancing.
> 
> This is my first attempt at kernel development, I'd love if you could
> please point out any mistakes that I've made.
> 
> Thanks,
> Gabríel
> 
> P.S. I could not figure out how to subscribe to this mailing list, so
> please remember to include me in your replies.

Hi, Gabríel,

To subscribe to the mailing list, all you have to do is email
majordomo@vger.kernel.org with "subscribe linux-btrfs" in the body (see
http://vger.kernel.org/vger-lists.html#linux-btrfs). Also, be sure to
take a look at https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ
and https://www.kernel.org/doc/Documentation/SubmittingPatches
for instructions on how to send in patches. The biggest takeaway is to
use `git format-patch` and `git send-email`.

Thanks!
-- 
Omar
