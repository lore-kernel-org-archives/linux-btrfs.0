Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45495 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab2HHPVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 11:21:05 -0400
Date: Wed, 8 Aug 2012 17:20:59 +0200
From: David Sterba <dave@jikos.cz>
To: Alexander Block <ablock84@googlemail.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove mnt_want_write call in btrfs_mksubvol
Message-ID: <20120808152059.GY17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
 <20120803211317.GA10080@localhost.localdomain>
 <CAB9VWqAU5THN7Lb9Y35pGBr1ewmtYmqsX6B-x7Lx3BiAUW4FgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB9VWqAU5THN7Lb9Y35pGBr1ewmtYmqsX6B-x7Lx3BiAUW4FgQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2012 at 01:39:25AM +0200, Alexander Block wrote:
> On Fri, Aug 3, 2012 at 11:13 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > I'm confused, this isn't here in btrfs-next, so is this a problem still?
>
> It's in linus current master. Lio Bo moved the call out of
> btrfs_mksubvol into the caller. Later a commit from Jan Kara tried to
> move the call inside mksubvol below i_mutex. If I understand the logs
> correctly, It was then merged incorrectly.

How should we resolve this? The patch has to be pulled via a separate
branch, based on top of linus/master, as cmason/for-linus does not have
the clashing freezer patches. And I do want to see the fix in master
rather soon as it makes testing tedious.

david
