Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab3HGMiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 08:38:15 -0400
Date: Wed, 7 Aug 2013 14:38:12 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: introduce command namespace for
 development features
Message-ID: <20130807123812.GQ5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1375791411.git.dsterba@suse.cz>
 <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz>
 <20130806180137.GM12314@lenny.home.zabbo.net>
 <20130807112658.GP5284@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130807112658.GP5284@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 01:26:58PM +0200, David Sterba wrote:
> I have to re-organize integration branch(es) better, so there is eg. a
> branch without unstable stuff, possibly always in a pullable state. On
> top of that a bunch of topic branches with the _ features.

... but then there's no point hiding the commands under _ hmm.
