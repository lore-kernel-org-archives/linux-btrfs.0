Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbbKXRlH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 12:41:07 -0500
Date: Tue, 24 Nov 2015 18:39:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
Message-ID: <20151124173921.GL31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56455073.1060406@cn.fujitsu.com>
 <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net>
 <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de>
 <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net>
 <56526790.6020907@cn.fujitsu.com>
 <1448302368.2100.28.camel@scientia.net>
 <5653B34B.9000103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5653B34B.9000103@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2015 at 08:46:03AM +0800, Qu Wenruo wrote:
> 
> 
> Christoph Anton Mitterer wrote on 2015/11/23 19:12 +0100:
> > On Mon, 2015-11-23 at 09:10 +0800, Qu Wenruo wrote:
> >> Also, you won't want compiler to do extra optimization
> > I did the following:
> > $ export CFLAGS="-g -O0 -Wall -D_FORTIFY_SOURCE=2"
> 
> Wow, I didn't ever know it's possible to override FORTIFY_SOURCE to 
> suppress the warning.

FWIW, my tip:

make EXTRA_CFLAGS='-g -O0 -U_FORTIFY_SOURCE'
