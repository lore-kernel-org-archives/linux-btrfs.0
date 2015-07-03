Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:34146 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbGCRvZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 13:51:25 -0400
Received: by vnbf7 with SMTP id f7so10349320vnb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 10:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97D07H1LaE=Qa=jUtwGp16oyh6YWEL7YbOKNTU9jBbaL+Q@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
	<pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net>
	<1477911.JnaWx19SzT@merkaba>
	<CAC=t97D07H1LaE=Qa=jUtwGp16oyh6YWEL7YbOKNTU9jBbaL+Q@mail.gmail.com>
Date: Fri, 3 Jul 2015 11:51:24 -0600
Message-ID: <CAJCQCtTvb8dqeMsnxGZeU7A1rUDZV5mvRmZ3u=DF2uAZMGoiSw@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 3, 2015 at 9:05 AM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:

> I did some more digging and found that I had a lot of errors basically
> every drive.

Ick. Sucks for you but then makes this less of a Btrfs problem because
it can really only do so much if more than the number of spares have
problems. It does suggest a more aggressive need for the volume to go
read only in such cases though, before it gets this corrupt.

Multiple disk problems like this though suggest a shared hardware
problem like a controller or expander.


> So one particularly bad drive + multiple raid56 caveats + all the
> other drives behaving a little funny + a guy who didn't read as well
> as he should, and I really can't be surprised at the result.
>
> So I've decided to cash in the pool for some valueable lessons and
> move on.  Thanks to everybody for your thoughts and help here and on
> IRC (a responsive IRC, that's a refereshing difference) and I'll see
> what adventures btrfs round 2 brings.

Yep!


-- 
Chris Murphy
