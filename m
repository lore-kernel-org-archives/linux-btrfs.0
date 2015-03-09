Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbCILAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 07:00:21 -0400
Date: Mon, 9 Mar 2015 12:00:18 +0100
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: convert: show progress by default
Message-ID: <20150309110018.GB5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425051165-23376-1-git-send-email-dsterba@suse.cz>
 <CALJXSJov2K5M7RAAn4_i50Qvdc8ns9jy+LgCzhPJVQEwemLZsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALJXSJov2K5M7RAAn4_i50Qvdc8ns9jy+LgCzhPJVQEwemLZsg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 04, 2015 at 01:21:02AM -0500, Jérôme Poulin wrote:
> On Fri, Feb 27, 2015 at 10:32 AM, David Sterba <dsterba@suse.cz> wrote:
> >
> > +       printf("\t-p           show converting progress (default)\n");
> 
> A quick look a this it looks like you've added a mandatory «option»
> since the "case" which handle -p can only turn on this flag. Logic
> should be switched to -q for quiet mode instead.

I'll add an option to disable the progress, that'd still print the main
phases like before. Thanks.
