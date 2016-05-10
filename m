Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32807 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbcEJXmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 19:42:52 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so5945391wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2016 16:42:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160510133359.GS29353@twin.jikos.cz>
References: <1462839210-10040-1-git-send-email-nsteeves@gmail.com>
	<20160510133359.GS29353@twin.jikos.cz>
Date: Tue, 10 May 2016 19:42:50 -0400
Message-ID: <CAD=QJKjYTv4-7srx2zPTJNnF97BFFsQ4kLz3+PpC_Qgfb3b33Q@mail.gmail.com>
Subject: Re: [PATCH] Trivial fix for typos in comments.
From: Nicholas D Steeves <nsteeves@gmail.com>
To: dsterba@suse.cz, Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 May 2016 at 09:33, David Sterba <dsterba@suse.cz> wrote:
> On Mon, May 09, 2016 at 08:13:29PM -0400, Nicholas D Steeves wrote:
>> Trivial fix for typos in comments; I hope this patch isn't a nuisance!
>
> No, but I don't see the typos in any of the branches (master or the
> for-next snapshots).

Sorry, I used for-linus, while following this guide:
"git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
for-linus"
https://btrfs.wiki.kernel.org/index.php/Writing_patch_for_btrfs

and "git checkout master" confirms that I'm already on 'master', but
"git rebase next" produces the error:

fatal: Needed a single revision
invalid upstream next

I'm very new to git.  Should I have cloned the whole linux-btrfs.git
without "for-linus"?  Am I on the a master branch for the for-linus
module, which is separate from the master branch of the main
linux-btrfs?

On 10 May 2016 at 10:20, David Sterba <dsterba@suse.cz> wrote:
Message-ID: <20160510142028.GU29353@twin.jikos.cz>
> On Mon, May 09, 2016 at 08:13:29PM -0400, Nicholas D Steeves wrote:
> I ran ispell on the strings from comments, there are like 90+ typos
> (attached) that seem worth fixing, if you like.

Thank you for the list, I'd be happy to.  Are patches against master
or next preferred (I don't see a for-next branch)?

Kind regards,
Nicholas
