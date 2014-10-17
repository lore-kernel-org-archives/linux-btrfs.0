Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60529 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaJQSJb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 14:09:31 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so997531vcb.16
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 11:09:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413550386.755.1@mail.thefacebook.com>
References: <20141017085448.GA1050018@mother.pipebreaker.pl>
	<1413550386.755.1@mail.thefacebook.com>
Date: Fri, 17 Oct 2014 14:09:30 -0400
Message-ID: <CAGfcS_muumP4VQTUkTTGqg=RpjWrU1A5cC+g4=dKMbdMoQvmXg@mail.gmail.com>
Subject: Re: unexplainable corruptions 3.17.0
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Mason <clm@fb.com>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 8:53 AM, Chris Mason <clm@fb.com> wrote:
> This sounds like the problem fixed with some patches to our extent mapping
> code  that went in with the merge window.  I've cherry picked a few for
> stable and I'm running them through tests now.  They are in my stable-3.17
> branch, and I'll send to Greg once Linus grabs the revert for the last one.

Just for clarity - when can we expect to see these in the kernel?  I
wasn't sure which merge windows you're referring to.  I take it that
3.17.1 is still unpatched (for this and the readonly snapshot issue -
which requires reverting 9c3b306e1c9e6be4be09e99a8fe2227d1005effc).
