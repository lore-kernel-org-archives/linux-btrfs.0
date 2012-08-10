Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58584 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab2HJNZj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 09:25:39 -0400
Date: Fri, 10 Aug 2012 09:25:36 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Chris Samuel <chris@csamuel.org>
CC: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Josef Bacik <JBacik@fusionio.com>, David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
Message-ID: <20120810132536.GI32103@shiny>
References: <20120808161819.GO25996@vicerveza.homeunix.net>
 <20120808173645.GA17430@twin.jikos.cz>
 <20120808174011.GD2141@localhost.localdomain>
 <20120808175606.GQ25996@vicerveza.homeunix.net>
 <20120808175833.GC4185@shiny>
 <20120810094959.GT25996@vicerveza.homeunix.net>
 <50250346.5010807@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <50250346.5010807@csamuel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2012 at 06:49:10AM -0600, Chris Samuel wrote:
> On 08/10/2012 07:49 PM, Lluís Batlle i Rossell wrote:
> 
> > Am I right that it is not in 3.5.1?
> 
> I don't believe fixes can be considered for stable releases until 
> they're in the mainline, so until Linus processes that last merge 
> request from Chris it can't happen (and he's not done so yet).
> 
> That said, there was one btrfs fix merged into 3.5.1:
> 
> Chris Mason (1):
>        Btrfs: call the ordered free operation without any locks held
> 
> But I suspect that is not the fix you are looking for..

Right, this fix was bigger than we could send to stable yet.  For now
you need to run my for-linus tree against 3.5 (or 3.5.1) for the fixes.

-chris
