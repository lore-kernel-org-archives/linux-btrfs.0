Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49391 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab3LESuH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 13:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131205181908.26814.83252@ret>
References: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
	<CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
	<20131205181908.26814.83252@ret>
Date: Thu, 5 Dec 2013 10:50:06 -0800
Message-ID: <CA+55aFzMA6gu9cMV5jbfC9quGBJNfh5JdO=dvPOggTwX9io95A@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs Maintainer update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 5, 2013 at 10:19 AM, Chris Mason <clm@fb.com> wrote:
>
> I had used git commit -S instead of signing the tag.

Ahh. And that was actually what you had done the first time around for
your test too - but back then I didn't actually *merge* it. Then I
just looked at the top commit and said "yup, it's signed".

And now that I tried to merged it, I noticed my merge commit didn't
get the signage I expected.

And that only happens if I pull a tag that's signed (which also gets
me the message I expect from signed pulls)..

Anyway, now I have both a signature on the merge and on your actual
commit. Thanks,

             Linus
