Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46843 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2JGWjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Oct 2012 18:39:44 -0400
Date: Mon, 8 Oct 2012 00:39:41 +0200
From: David Sterba <dave@jikos.cz>
To: Alex <alex@bpmit.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Wiki (scrub)
Message-ID: <20121007223941.GE4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <loom.20121007T140200-885@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20121007T140200-885@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sun, Oct 07, 2012 at 12:07:43PM +0000, Alex wrote:
> The official wiki seems to have lost references to "scrub" if not other
> commands.

AFAIK there was no separate page for scrub, it is not covered in the
FAQ section but has an entry in the Glossary.

> The last changes iss filled with account creation so I can't see
> easily when that happened.

Yeah, the user-creation spam is awful, the brave wiki admin at least
blocks the users that get past the authentication and pollute pages.

I'm using the a filter to see only page changes:
* select 'User' namespace
* [x] Invert selection
* Go

> Have I missed a policy change go through which is not reflected in the
> (Debian/Siduction) btrfs userland program yet or has something else happened?

Are you asking about 'scrub' support in the progs? Oterwise I don't
understand the question and tend to answer 'Yes', because it answers the
second part.


david
