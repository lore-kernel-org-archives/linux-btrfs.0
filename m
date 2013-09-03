Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760838Ab3ICUzL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 16:55:11 -0400
Message-ID: <52264CAC.6000708@redhat.com>
Date: Tue, 03 Sep 2013 15:55:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 V2] Btrfs-progs: move btrfs cmd files to cmd/ subdir
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com> <1370992519-21369-4-git-send-email-sandeen@redhat.com> <51B7C2EB.8090509@redhat.com> <20130902144529.GA23113@twin.jikos.cz>
In-Reply-To: <20130902144529.GA23113@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/2/13 9:45 AM, David Sterba wrote:
> On Tue, Jun 11, 2013 at 07:38:03PM -0500, Eric Sandeen wrote:
>> Move btrfs cmd files to cmd/ subdir
> 
> Are you ok with naming the subdirectory 'cmds'?
> 
> david
> 

yep!  That's the _last_ bike shed I want to paint.  ;)

I had picked "cmd" because they are for the btrfs command (singular),
but *shrug* - it really doesn't matter to me.

-Eric
