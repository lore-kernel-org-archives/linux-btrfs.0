Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbcBVLeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 06:34:21 -0500
Date: Mon, 22 Feb 2016 12:34:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Philippe Loctaux <phil@philippeloctaux.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [Question]: Contributing to btrfs
Message-ID: <20160222113412.GB4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160220210903.GA3182@carbon.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160220210903.GA3182@carbon.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Feb 20, 2016 at 10:09:03PM +0100, Philippe Loctaux wrote:
> I'm new to the mailing list and btrfs in general (I've been using it for
> two weeks on my new arch install) and I'd like to contribute to the code :)

contributions to code are welcome, but please try not to spend too much
time fixing style problems or checkpatch warnings. This may be a good
start to get used to the patch formatting, mails and the feedback loop,
which you seem to understand now.

But otherwise whitespace-only changes are not considered worth the time,
and I don't want to encourage people to do that. My usual answer to that
is at

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Cleanup_projects

"Please note that pure whitespace and style reformatting changes are not
really necessary at this phase of development. They get fixed along
regular changes. Possibly once upon in a while a patch that fixes many
if not all whitespace errors could work, but otherwise it's considered a
noise."
