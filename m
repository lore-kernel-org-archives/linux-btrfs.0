From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Date: Fri, 11 Jun 2010 13:00:02 -0700
Message-ID: <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
References: <20100611193731.GA3018@think>
	<AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
	<20100611194812.GD3018@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100611194812.GD3018@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 11, 2010 at 12:48 PM, Chris Mason <chris.mason@oracle.com> wrote:
>
> The others all fix oopsen or big problems, and I think fixing warnings
> helps avoid false negatives as others look for real problems?
>
> I'm happy to rebase out the 3 non-criticals.

There seems to be more than three non-criticals. There's the warning
fixes, the "unused variables" thing, the "memdup_user()" thing, a
couple of unnecessary NULL checks removed etc. On the whole, I do not
get the feeling that the pull request was actively trying to be
minimal, and that's what I really want to see.

                  Linus
