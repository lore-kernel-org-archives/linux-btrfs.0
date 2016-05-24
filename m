Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbcEXKvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 May 2016 06:51:07 -0400
Date: Tue, 24 May 2016 12:50:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: [1/1 v2] String and comment review: Fix typos; fix a couple of
 mandatory grammatical issues for clarity.
Message-ID: <20160524105034.GO29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463707125-21899-1-git-send-email-nsteeves@gmail.com>
 <1463707125-21899-2-git-send-email-nsteeves@gmail.com>
 <CAD=QJKgZE8Dz_GgNpC5U85nd-FD5P_2k=UJwCMBhqFzL2H+DHA@mail.gmail.com>
 <20160523170123.GM29147@twin.jikos.cz>
 <CAD=QJKg-+=YXJH6koQ+f-xRWfHp0N9B3m_ObxrtmNhKSfer_Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKg-+=YXJH6koQ+f-xRWfHp0N9B3m_ObxrtmNhKSfer_Yg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 23, 2016 at 02:26:46PM -0400, Nicholas D Steeves wrote:
> On 23 May 2016 at 13:01, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, May 19, 2016 at 09:30:49PM -0400, Nicholas D Steeves wrote:
> >> Sorry for the noise.  Please disregard my v1 patch and subsequent
> >> emails.  This patch is for upstream linux-next.  From now on I think
> >> that's what I'm going to work from, to keep things simple, because it
> >> seems I'm still inept with git.
> >
> > The patch applies cleanly on top of the current branch that's going to
> > Linus tree, so I'll queue it for the next pull request. All your inline
> > notices were addressed. Thanks.
> 
> You're welcome, and thank you for the assistance.  I don't want to
> annoy everyone with a regular stream of these patches, so what do you
> think of the the following?:  I'll submit a patch for user-facing
> typos in btrfs-progs when I find one,

Sending typo fixes for all user visible text is OK and welcome anytime.

> if I find any, and a strings &
> comments review for both -progs and kernel twice a year, where one
> review is part of preparing for an LTS kernel.

Typos in comments can be done once in a year I think.
