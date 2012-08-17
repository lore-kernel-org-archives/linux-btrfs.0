Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63019 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab2HQBXI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 21:23:08 -0400
Received: by obbuo13 with SMTP id uo13so4506733obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 18:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120816221758.GM11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com>
	<20120814123937.GA14756@sig21.net>
	<502B8FE3.7080501@oberhumer.com>
	<20120815144539.GA8300@sig21.net>
	<502C92C3.7090701@oberhumer.com>
	<20120816150647.GA22010@sig21.net>
	<20120816232549.4d14a6aa@natsu>
	<20120816175234.GL11413@one.firstfloor.org>
	<CAMuHMdWK_Y=QwkgQD6K8tFBLaO04Fy0yVAzEpb2OYW6Ec0hGoA@mail.gmail.com>
	<CAPkEcwgv6f5B+Mrw7kzrHcZ5JZ+Yr0o=bLdoFqCB-e4CLiVx5A@mail.gmail.com>
	<20120816221758.GM11413@one.firstfloor.org>
Date: Thu, 16 Aug 2012 20:23:06 -0500
Message-ID: <CAKcLGm97zq7kx43cMyDwythin+R01E4zrtzrjAKkJjQL0iy+mg@mail.gmail.com>
Subject: Re: [GIT PULL] Update LZO compression
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: james northrup <northrup.james@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Mamedov <rm@romanrm.ru>, Johannes Stezenbach <js@sig21.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2012 at 5:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Aug 16, 2012 at 11:55:06AM -0700, james northrup wrote:
>> looks like ARM results are inconclusive from a lot of folks without
>> bandwidth to do a write-up, what about just plain STAGING status for ARM so
>> the android tweakers can beat on it for a while?
>
> Staging only really works for new drivers, not for updating existing
> library functions like this.
>
> I suppose you could keep both and have the architecture select with a
> CONFIG.
>

I've been doing some rough benchmarking with the updated LZO in btrfs.

My tests primarily consist of timing some typical copying, git
manipulating, and running rsync using a set of kernel git sources.
Git sources are typically about 50% pack files which won't compress
very well, with the remainder being mostly highly compressible source
files.

Of course, any underlying speed improvement attributable only to LZO
is not shown by test like this. But I thought it would be interesting
to see the impact in some typical real-world btrfs operations.

I was seeing between 3-9% improvement in speed with the new LZO.

Copying several directories of git sources showed the most
improvement, ~9%.  Typical git operations, such as a git checkout or
git status where only showing 3-5% improvement, which is close to the
noise level of my tests.  Running multiple rsync processes showed a 5%
improvement.

With only 10 trials (5 with each LZO), I can't say I would
statistically hang my hat on these numbers.

Given all the other stuff that is going on in my rough benchmarks, a
3-9% improvement from a single change is probably pretty good.
