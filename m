Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22129 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723Ab3LETCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Dec 2013 14:02:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Chris Mason <clm@fb.com>
In-Reply-To: <CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
 <CA+55aFz3sxb5h+m2eC8KniJjE4dA1F2Pzcu=9DfZRRzZakiBDw@mail.gmail.com>
Message-ID: <20131205181908.26814.83252@ret>
Subject: Re: [GIT PULL] Btrfs Maintainer update
Date: Thu, 5 Dec 2013 13:19:09 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Linus Torvalds (2013-12-05 12:53:26)
> On Wed, Dec 4, 2013 at 9:53 AM, Chris Mason <clm@fb.com> wrote:
> >
> > Instead of diffstat etc, I've put the patch below.  The commit is also
> > signed, my updated key should be floating around the pgp servers now.
> 
> You've done something to the git tree since your test request, because
> now the signed tag isn't there any more, now it's just a regular
> branch.
> 
> Mind re-uploading the *tag*, which is where the signature is?

I had used git commit -S instead of signing the tag.  I just pushed out
a signed tag on for-linus as well.

-chris

