Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33983 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab2FNKmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 06:42:32 -0400
Date: Thu, 14 Jun 2012 12:42:27 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <josef@redhat.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use rcu to protect device->name V2
Message-ID: <20120614104227.GQ32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339530642-13862-1-git-send-email-josef@redhat.com>
 <20120612223526.GJ32402@twin.jikos.cz>
 <20120613131426.GA2186@localhost.localdomain>
 <4FD89A53.1060704@giantdisaster.de>
 <20120613135103.GA5461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120613135103.GA5461@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 09:51:03AM -0400, Josef Bacik wrote:
> On Wed, Jun 13, 2012 at 03:49:07PM +0200, Stefan Behrens wrote:
> > The last sentence of chapter 2 of Documentation/CodingStyle is quite
> > unambiguous. Here is the full quote of that chapter:
> > 
> >                 Chapter 2: Breaking long lines and strings
> > 
> > Coding style is all about readability and maintainability using commonly
> > available tools.
> > 
> > The limit on the length of lines is 80 columns and this is a strongly
> > preferred limit.
> > 
> > Statements longer than 80 columns will be broken into sensible chunks,
> > unless
> > exceeding 80 columns significantly increases readability and does not hide
> > information. Descendants are always substantially shorter than the
> > parent and
> > are placed substantially to the right. The same applies to function headers
> > with a long argument list. However, never break user-visible strings such as
> > printk messages, because that breaks the ability to grep for them.
> 
> Ah never seen that part of it, I will leave them alone then.  Thanks,

Added not so long ago

commit 6f76b6fcaa6025bc9b2c00e055c7ccd39730568d
Author: Josh Triplett <josh@joshtriplett.org>
Date:   Wed Aug 3 12:19:07 2011 -0700

    CodingStyle: Document the exception of not splitting user-visible strings, for grepping

    Patch reviewers now recommend not splitting long user-visible strings,
    such as printk messages, even if they exceed 80 columns.  This avoids
    breaking grep.  However, that recommendation did not actually appear
    anywhere in Documentation/CodingStyle.

    See, for example, the thread at
      http://news.gmane.org/find-root.php?message_id=%3c1312215262.11635.15.camel%40Joe%2dLaptop%3e

